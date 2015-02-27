module Suscribir
  class SuscripcionDecorator < Draper::Decorator
    delegate_all

    def url_desuscribir
      h.engine_suscribir.pedir_confirmacion_baja_url(id, token)
    end

    def enlace_desuscripcion_url(texto_url)
      h.link_to(texto_url, url_desuscribir)
    end
  end
end


