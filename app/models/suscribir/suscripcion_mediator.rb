module Suscribir
  class SuscripcionMediator < ActiveRecord::Observer
    include ActiveModel::Observing

    observe 'Suscribir::Suscripcion'

    EVENTO_SUSCRIBIR = :suscribir

    def after_create(suscripcion)
      self.class.notify_observers(EVENTO_SUSCRIBIR, suscripcion)
    end
  end
end
