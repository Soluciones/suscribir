# coding: UTF-8

module Suscribir
  class Suscripcion < ActiveRecord::Base
    belongs_to :suscribible, polymorphic: true
    belongs_to :suscriptor, polymorphic: true

    validates :suscribible_type, :suscribible_id, presence: true
    validates :dominio_de_alta, presence: true
    validates :email, presence: true, uniqueness: { scope: [:suscribible_type, :suscribible_id, :dominio_de_alta] }
  end
end
