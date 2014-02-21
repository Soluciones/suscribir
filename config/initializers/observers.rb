# coding: UTF-8

unless Rails.env.test?
  Suscribir::Suscripcion.add_observer Suscribir::SuscripcionAddToSendGridObserver.new
  Suscribir::Suscripcion.add_observer Suscribir::SuscripcionSetUserIfFoundObserver.new
end
