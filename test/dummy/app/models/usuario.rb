# coding: UTF-8

class Usuario < ActiveRecord::Base
  include Suscribir::Suscriptor
end
