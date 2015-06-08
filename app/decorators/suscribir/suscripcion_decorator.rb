module Suscribir
  class SuscripcionDecorator < Draper::Decorator
    delegate_all

    def url_desuscribir
      "#{ HTTP_DOMINIOS[dominio_de_alta.to_sym] }/suscribir/confirmar_baja/#{ id }/#{ token }"
      # SI QUIERES INTENTAR HACERLO BIEN CON
      # h.engine_suscribir.pedir_confirmacion_baja_url(id, token, host: mi_dominio)
      # ASEGURATE DE QUE TE FUNCIONE DESDE EL CRON
    end

    def link_desuscribir
      h.link_to "Desuscribirte de #{ suscribible.name }", url_desuscribir
    end
  end
end
