module Suscribir
  class SuscripcionMailer < ActionMailer::Base

    default from: ::Suscribir::Personalizacion.email_contacto, to: 'noreply@noreply.me.please'

    def desuscribir(suscripcion, url_resuscripcion)
      @url_suscribirme_otra_vez = url_resuscripcion
      mail(to: suscripcion.email, subject: 'Confirmación baja de la newsletter')
    end
  end
end
