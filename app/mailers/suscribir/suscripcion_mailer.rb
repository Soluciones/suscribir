module Suscribir
  class SuscripcionMailer < ActionMailer::Base

    default from: ConstantesEmail::REMITENTE_INFO, to: ConstantesEmail::NO_REPLY

    def desuscribir(suscripcion)
      @url_suscribirme_otra_vez = '#'
      mail(to: suscripcion.email, subject: 'Confirmación baja de la newsletter')
    end
  end
end
