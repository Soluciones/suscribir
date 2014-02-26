# coding: UTF-8

module Suscribir
  class SuscripcionDeleteFromSendGridObserver
    require 'gatling_gun'

    @sendgrid = nil

    def initialize(*args)
      acceso = args.first if args.present?
      configura_sendgrid(acceso)
    end

    def update(metodo, suscripcion)
      return unless metodo.to_sym == Suscripcion::EVENTO_DESUSCRIBIR

      nombre_lista = dame_nombre_lista(suscripcion)
      eliminar_suscriptor_de_lista(nombre_lista, suscripcion.email)
    end

  private
    def configura_sendgrid(acceso)
      @sendgrid = case acceso.class.to_s
        when 'GatlingGun'
          acceso
        when 'Hash'
          GatlingGun.new(acceso[:user], acceso[:password])
        else
          usuario = Rails.application.class::ENV_CONFIG["SENDGRID_USER_NAME"]
          password = Rails.application.class::ENV_CONFIG["SENDGRID_PASSWORD"]
          GatlingGun.new(usuario, password)
      end
    end

    def sendgrid
      @sendgrid
    end

    def dame_nombre_lista(suscripcion)
      suscribible = suscripcion.suscribible
      "#{suscribible.nombre} (#{suscribible.class.model_name} id: #{suscribible.id})"
    end

    def eliminar_suscriptor_de_lista(nombre_lista, email)
      sendgrid.delete_email(nombre_lista, email)
    end
  end
end
