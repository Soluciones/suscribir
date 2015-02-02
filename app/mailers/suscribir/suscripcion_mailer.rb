module Suscribir
  class SuscripcionMailer < ActionMailer::Base

    default from: ::Suscribir::Personalizacion.email_contacto, to: 'noreply@noreply.me.please'

    def desuscribir(suscripcion)
      @url_suscribirme_otra_vez = '#'
      mail(to: suscripcion.email, subject: 'Confirmación baja de la newsletter')
    end
  end
end
