# coding: UTF-8

module Suscribir
  class SuscripcionSyncSendGridObserver
    require 'gatling_gun'

    @sendgrid = nil

    def initialize(*args)
      acceso = args.first if args.present?
      configura_sendgrid(acceso)
    end

    def update(metodo, suscripcion)
      handler_method = "update_#{metodo}"
      send(handler_method, suscripcion) if respond_to? handler_method
    end

    def update_suscribir(suscripcion)
      sendgrid.add_list(suscripcion.nombre_lista) unless lista_existe?(suscripcion.nombre_lista)
      datos_suscriptor = dame_atributos_del_suscriptor(suscripcion)
      sendgrid.add_email(suscripcion.nombre_lista, datos_suscriptor)
    end

    def update_desuscribir(suscripcion)
      sendgrid.delete_email(suscripcion.nombre_lista, suscripcion.email)
    end

  private
    def configura_sendgrid(acceso)
      @sendgrid = case acceso.class.to_s
        when 'GatlingGun'
          acceso
        when 'Hash'
          GatlingGun.new(acceso[:user], acceso[:password])
        else
          usuario = Rails.application.secrets.sendgrid_user_name
          password = Rails.application.secrets.sendgrid_password
          GatlingGun.new(usuario, password)
      end
    end

    def sendgrid
      @sendgrid
    end
    def lista_existe?(nombre_lista)
      sendgrid.get_list(nombre_lista).success?
    end

    def dame_atributos_del_suscriptor(suscripcion)
      {
        email: suscripcion.email,
        name: suscripcion.nombre_apellidos,
      }
    end
  end
end
