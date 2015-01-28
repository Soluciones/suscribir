Suscribir::Engine.routes.draw do
  get '/confirmar_baja/:suscripcion_id/:token' => 'suscripciones#pedir_confirmacion_baja', as: 'pedir_confirmacion_baja'
  delete '/baja/:suscripcion_id/:token' => 'suscripciones#desuscribir', as: 'desuscribir'
  get '/baja_realizada/:type/:suscribible_id/:email/:token' => 'suscripciones#baja_realizada', as: 'baja_realizada'
end
