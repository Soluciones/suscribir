# coding: UTF-8

module Suscribir
  class SuscripcionSyncSendGridObserver
    require 'gatling_gun'

    def initialize(*args)
      acceso = args.first if args.present?
      configura_sendgrid(acceso)
    end

    def update(metodo, suscripcion)
      handler_method = "update_#{metodo}"
      send(handler_method, suscripcion) if respond_to? handler_method
    end

    def update_suscribir(suscripcion)
      @sendgrid.add_list(suscripcion.nombre_lista) unless lista_existe?(suscripcion.nombre_lista)
      datos_suscriptor = dame_atributos_del_suscriptor(suscripcion)
      @sendgrid.add_email(suscripcion.nombre_lista, datos_suscriptor)
    end

    def update_desuscribir(suscripcion)
      @sendgrid.delete_email(suscripcion.nombre_lista, suscripcion.email)
    end

  private
    def configura_sendgrid(acceso)
      @sendgrid = case acceso.class.to_s
        when 'GatlingGun'
          acceso
        when 'Hash'
          GatlingGun.new(acceso[:user], acceso[:password])
        else
          if Rails.env.production?
            usuario = ENV_CONFIG['SENDGRID_USER_NAME']
            password = ENV_CONFIG['SENDGRID_PASSWORD']
          else
            usuario = 'usuario_sendgrid'
            password = 'p455W0rd_s3nd6r1d'
          end
          GatlingGun.new(usuario, password)
      end
    end

    def lista_existe?(nombre_lista)
      @sendgrid.get_list(nombre_lista).success?
    end

    def dame_atributos_del_suscriptor(suscripcion)
      {
        email: suscripcion.email,
        name: suscripcion.nombre_apellidos,
      }
    end
  end
end
