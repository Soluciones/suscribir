suscribir
=========

[![Code Climate](https://codeclimate.com/github/Soluciones/suscribir.png)](https://codeclimate.com/github/Soluciones/suscribir)

Permite suscribirse a cualquier cosa suscribible (tematicas, hilos, news general... ¿etiquetas, usuarios?)

### Configurar para que use la working copy local

    > bundle config local.suscribir ../suscribir

### Deshacer configuración para volver a usar git en lugar de la working copy

    > bundle config --delete local.suscribir

## Control de versiones

### Incrementar versión en el código

Cuando el cambio ya está _mergeado_ en `master`, es hora de incrementar el contador de versiones para hacer la subida. En `lib/suscribir/version.rb`:

    module Suscribir
      VERSION = "0.5.1"
    end

### Escribir changelog

En `changelog.txt`, se comentan las características que se han añadido en esta versión.

###  Subir cambios a git y crear _tag_

En la línea de comandos, desde el directorio del engine:

    > git commit -m "Cambio de version"
    > git push origin
    > git tag 6.0.0
    > git push origin 6.0.0

### App principal

Una vez esta creado el _tag_ de la nueva versión, vamos a las aplicaciones principales y editamos la línea del Gemfile:

    gem 'suscribir', git: 'git@github.com:Soluciones/suscribir.git', branch: 'master', tag: '6.0.0'


Y lanzamos `bundle update --source suscribir` para que actualice a la nueva versión.
