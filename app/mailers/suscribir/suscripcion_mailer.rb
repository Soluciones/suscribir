module Suscribir
  class SuscripcionMailer < ActionMailer::Base

    default from: ConstantesEmail::REMITENTE_INFO, to: ConstantesEmail::NO_REPLY

    def desuscribir(suscripcion, url_resuscripcion)
      @url_suscribirme_otra_vez = url_resuscripcion
      mail(to: suscripcion.email, subject: 'Confirmación baja de la newsletter')
    end
  end
end
