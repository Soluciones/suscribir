class Tematica < ActiveRecord::Base
  include Suscribir::Suscribible
  def self.dame_general
    self.new(nombre: 'Newsletter General').tap { |general| general.id = 0 }
  end
end
