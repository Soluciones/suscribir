Suscribir
=========

[![Code Climate](https://codeclimate.com/github/Soluciones/suscribir.png)](https://codeclimate.com/github/Soluciones/suscribir)

Permite suscribirse a cualquier cosa suscribible (tematicas, hilos, news general... ¿etiquetas, usuarios?)


## Setup

1. Añadir el engine en el `Gemfile`
2. Instanciar los observers en `config/initializers/observers.rb`

    ```ruby
    unless Rails.env.test?
      Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSyncSendGridObserver.new
      Suscribir::SuscripcionMediator.add_observer Suscribir::SuscripcionSetUserIfFoundObserver.new
    end
    ```
