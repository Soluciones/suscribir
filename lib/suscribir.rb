require 'suscribir/engine'
require 'haml-rails'
require 'psique'
require 'draper'
require 'ssl_requirement'

module Suscribir
  module Personalizacion
    mattr_accessor :layout, :email_contacto, :email_contacto_en_confirmacion_baja, :partial_columna
  end
end
