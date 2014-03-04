module Suscribir
  class SuscripcionMediator < ActiveRecord::Observer
    include ActiveModel::Observing

    observe 'Suscribir::Suscripcion'

    EVENTO_SUSCRIBIR = :suscribir
    EVENTO_DESUSCRIBIR = :desuscribir

    def after_create(suscripcion)
      self.class.notify_observers(EVENTO_SUSCRIBIR, suscripcion)
    end

    def after_destroy(suscripcion)
      self.class.notify_observers(EVENTO_DESUSCRIBIR, suscripcion)
    end
  end
end
