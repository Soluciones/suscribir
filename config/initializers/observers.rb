# coding: UTF-8

Suscribir::Suscripcion.add_observer Suscribir::SuscripcionAddToSendGridObserver.new unless Rails.env.test?
