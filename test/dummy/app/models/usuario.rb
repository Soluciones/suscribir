# coding: UTF-8

class Usuario < ActiveRecord::Base
  include Suscribir::Suscriptor

  @nombre_apellidos = nil

  def nombre_apellidos
    @nombre_apellidos ||= "#{nombre} #{apellidos}"
  end

  def nombre_apellidos=(value)
    @nombre_apellidos = value
  end
end
