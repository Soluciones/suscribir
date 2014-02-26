module Suscribir
  class Engine < Rails::Engine
    isolate_namespace Suscribir

    config.active_record.observers = 'Suscribir::SuscripcionMediator'
  end
end
