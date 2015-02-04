if Rails.env.production?
  Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSyncSendGridObserver.new
  Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSetUserIfFoundObserver.new
end
