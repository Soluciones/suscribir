# coding: UTF-8

unless Rails.env.test?
  Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionAddToSendGridObserver.new
  Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSetUserIfFoundObserver.new
end
