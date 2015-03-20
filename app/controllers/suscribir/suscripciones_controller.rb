module Suscribir
  class SuscripcionesController < ApplicationController
    before_filter :pon_lateral, only: [:pedir_confirmacion_baja, :baja_realizada]
    before_filter :sin_breadcrumb
    before_action :set_suscribible_y_clase, only: [:resuscribir, :baja_realizada]
    layout ::Suscribir::Personalizacion.layout

    def pedir_confirmacion_baja
      @suscripcion = Suscripcion.find(params[:suscripcion_id])
      @suscribible = @suscripcion.suscribible_o_news_general
      render_404 unless params[:token] == @suscripcion.token
    end

    def resuscribir
      email = Base64.decode64(params[:email])

      ya_suscrito = @suscribible.suscripciones.find_by(email: email)
      return if ya_suscrito

      token_bueno = Suscripcion.new(email: email, suscribible_id: @suscribible.id, suscribible_type: @clase).token
      return render_404 unless params[:token] == token_bueno

      suscriptor = Usuario.find_by(email: email) || SuscriptorAnonimo.new(email)
      @suscribible.suscribe_a!(suscriptor, I18n.locale)
      SuscripcionMailer.resuscribir(suscriptor, @suscribible).deliver
    end

    def desuscribir
      suscripcion = Suscribir::Suscripcion.find(params[:suscripcion_id])
      params[:token] == suscripcion.token or return render_404
      encoded_email = Base64.encode64(suscripcion.email)
      clase = Base64.encode64(suscripcion.suscribible_type)
      token_bueno = suscripcion.token
      url_resuscripcion = resuscribir_url(clase, suscripcion.suscribible_id, encoded_email, token_bueno)

      suscripcion.destroy
      SuscripcionMailer.desuscribir(suscripcion, url_resuscripcion).deliver
      respond_to do |format|
        format.html do
          redirect_to baja_realizada_path(type: clase, suscribible_id: suscripcion.suscribible_id,
                                          email: encoded_email, token: token_bueno)
        end
        format.js { head :no_content }
      end
    end

    def baja_realizada
      @email = Base64.decode64(params[:email])
      token_bueno = Suscripcion.new(email: @email, suscribible_id: @suscribible.id, suscribible_type: @clase).token
      params[:token] == token_bueno or return render_404

      @url_resuscripcion = resuscribir_url(params[:type], params[:suscribible_id], params[:email], params[:token])
    end

    private

    def sin_breadcrumb
      @sin_breadcrumb = 'Sí, por favor, no me pongas breadcrumb'
    end

    def set_suscribible_y_clase
      if params[:suscribible_id] == '0'
        @suscribible = Tematica::Tematica.dame_general
        @clase = @suscribible.class
      else
        @clase = Base64.decode64(params[:type]).constantize
        @suscribible = @clase.find(params[:suscribible_id])
      end
    end
  end
end
