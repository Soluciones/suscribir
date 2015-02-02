require 'suscribir/engine'
require 'haml-rails'
require 'psique'
require 'rails-observers'
require 'draper'
require 'gatling_gun'

module Suscribir
  module Personalizacion
    mattr_accessor :layout, :email_contacto
  end
end
