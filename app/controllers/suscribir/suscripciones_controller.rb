module Suscribir
  class SuscripcionesController < ApplicationController
    before_filter :pon_lateral, only: [:pedir_confirmacion_baja, :baja_realizada]
    before_filter :sin_breadcrumb
    layout ::Suscribir::Personalizacion.layout

    def pedir_confirmacion_baja
      @suscripcion = Suscripcion.find(params[:suscripcion_id])
      render_404 unless params[:token] == @suscripcion.token
    end

    def resuscribir
      clase = Base64.decode64(params[:type])
      email = Base64.decode64(params[:email])

      suscribible = clase.constantize.find(params[:suscribible_id])
      token_bueno = Suscripcion.new(email: email, suscribible_id: suscribible.id, suscribible_type: clase).token
      return render_404 unless params[:token] == token_bueno

      suscriptor = Usuario.find_by(email: email) || SuscriptorAnonimo.new(email: email)
      suscriptor.suscribeme_a!(suscribible, I18n.locale)
    end

    def desuscribir
      suscripcion = Suscribir::Suscripcion.find(params[:suscripcion_id])
      params[:token] == suscripcion.token or return render_404
      enconded_email = Base64.encode64(suscripcion.email)
      email_tokenizada = tokeniza_email(enconded_email)
      clase = Base64.encode64(suscripcion.suscribible_type)
      url_resuscripcion = resuscribir_url(clase, suscripcion.suscribible_id, enconded_email, email_tokenizada)

      suscripcion.destroy
      SuscripcionMailer.desuscribir(suscripcion, url_resuscripcion).deliver
      redirect_to baja_realizada_path(type: clase, suscribible_id: suscripcion.suscribible_id,
                                      email: enconded_email, token: email_tokenizada)
    end

    def baja_realizada
      clase = Base64.decode64(params[:type]).constantize
      @suscribible = clase.find(params[:suscribible_id])
      email_tokenizada = tokeniza_email(params[:email])
      params[:token] == email_tokenizada or return render_404
      @email = Base64.decode64(params[:email])

      @url_resuscripcion = resuscribir_url(params[:type], params[:suscribible_id], params[:email], params[:token])
    end

    private

    def sin_breadcrumb
      @sin_breadcrumb = 'Sí, por favor, no me pongas breadcrumb'
    end
  end
end
