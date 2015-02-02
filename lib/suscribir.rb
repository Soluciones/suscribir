require 'suscribir/engine'
require 'haml-rails'
require 'psique'

module Suscribir
  module Personalizacion
    mattr_accessor :layout, :email_contacto
  end
end
