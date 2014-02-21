# coding: UTF-8

module Suscribir
  class SuscripcionAddToSendGridObserver
    require 'gatling_gun'

    @sendgrid = nil

    def initialize(*args)
      acceso = args.first if args.present?
      configura_sendgrid(acceso)
    end

    def update(metodo, suscripcion)
      return unless metodo.to_sym == Suscripcion::EVENTO_SUSCRIBIR

      nombre_lista = dame_nombre_lista(suscripcion)
      sendgrid.add_list(nombre_lista) unless lista_existe?(nombre_lista)
      datos_suscriptor = dame_atributos_del_suscriptor(suscripcion)
      anyadir_suscriptor_a_lista(nombre_lista, datos_suscriptor)
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

    def lista_existe?(nombre_lista)
      sendgrid.get_list(nombre_lista).success?
    end

    def anyadir_suscriptor_a_lista(nombre_lista, datos_suscriptor)
      sendgrid.add_email(nombre_lista, datos_suscriptor)
    end

    def dame_atributos_del_suscriptor(suscripcion)
      {
        email: suscripcion.email,
        nombre_apellidos: suscripcion.nombre_apellidos,
        cod_postal: suscripcion.cod_postal,
        provincia_id: suscripcion.provincia_id
      }
    end
  end
end
