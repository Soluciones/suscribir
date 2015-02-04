module Suscribir
  class Engine < Rails::Engine
    isolate_namespace Suscribir

    # Para que la applicación arranque los observers hay que registralos evitando sobreescribir los que hayan sido
    # asignados anteriormente por otras partes (por ejemplo, por otros engines)
    config.active_record.observers = [config.active_record.observers].flatten.compact
    config.active_record.observers << 'Suscribir::SuscripcionMediator'
  end
end

def tokeniza_email(email)
  Digest::SHA1.hexdigest("tokeniza_email_#{ Rails.application.secrets.esta_web_secret_token }_#{ email }")
end
