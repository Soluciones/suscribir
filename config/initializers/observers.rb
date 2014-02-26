# coding: UTF-8

unless Rails.env.test?
  Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSyncSendGridObserver.new
  Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSetUserIfFoundObserver.new
end
