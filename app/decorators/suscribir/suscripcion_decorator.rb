module Suscribir
  class SuscripcionDecorator < Draper::Decorator
    delegate_all

    def url_desuscribir
      h.engine_suscribir.pedir_confirmacion_baja_url(id, token)
    end
  end
end
