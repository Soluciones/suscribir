suscribir
=========

[![Build Status](https://travis-ci.org/Soluciones/suscribir.svg)](https://travis-ci.org/Soluciones/suscribir)
[![Code Climate](https://codeclimate.com/github/Soluciones/suscribir.png)](https://codeclimate.com/github/Soluciones/suscribir)

Permite suscribirse a cualquier cosa suscribible (tematicas, hilos, news general... ¿etiquetas, usuarios?)

## Migraciones

Una migración no funciona si se lanza en el root del engine:

    > rails g migration add_suscribir_id_to_redirections suscribir_id:integer

    => script/rails:8:in 'require': cannot load such file -- rails/engine/commands (LoadError)
    => from script/rails:8:in 'main>'

Hay que lanzarla en dummy:

    > cd test/dummy
    > rails g migration add_suscribir_id_to_redirections suscribir_id:integer

    => invoke  active_record
    => create    db/migrate/20130626151549_add_suscribir_id_to_redirections.rb

    > mv db/migrate/20130626151549_add_suscribir_id_to_redirections.rb ../../db/migrate/
    > rake db:migrate


Luego, habrá que importar las migraciones a la app principal que vaya a usar el engine:

    > rnk
    > rake suscribir:install:migrations
    > rdbp


**OJO:** Si tenemos el *database.yml* apuntando a la misma BD (que no deberíamos), el `rake db:migrate` de la app fallará porque "el campo ya existe", habrá que ajustarlo a mano... **FAIL**.


### Configurar para que use la working copy local

    > bundle config local.suscribir ../suscribir

### Deshacer configuración para volver a usar git en lugar de la working copy

    > bundle config --delete local.suscribir

## Control de versiones

### Incrementar versión en el código

Cuando el cambio ya está _mergeado_ en `master`, es hora de incrementar el contador de versiones para hacer la subida. En `lib/suscribir/version.rb`:

    module Suscribir
      VERSION = "6.0.0"
    end

### Escribir changelog

En `changelog.txt`, se comentan las características que se han añadido en esta versión.

###  Subir cambios a git y crear _tag_

En la línea de comandos, desde el directorio del engine:

    > git commit -m "Cambio de version"
    > git push origin
    > rake release

### App principal

Una vez esta creado el _tag_ de la nueva versión, vamos a las aplicaciones principales y editamos la línea del Gemfile:

    gem 'suscribir', git: "https://github.com/Soluciones/suscribir.git", tag: '6.0.0'


Y lanzamos `bundle update --source suscribir` para que actualice a la nueva versión.
