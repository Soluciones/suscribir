# coding: UTF-8

require 'active_support/concern'

module Suscribir::Suscribible
  extend ActiveSupport::Concern

  included do
    has_many :suscripciones, as: :suscribible , class_name: 'Suscribir::Suscripcion'
  end

  def busca_suscripcion(suscriptor, dominio_de_alta)
    suscripciones.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta).first
  end

  def busca_suscripciones(dominio_de_alta)
    suscripciones.where(dominio_de_alta: dominio_de_alta)
  end

  def suscribe_a!(suscriptor, dominio_de_alta = 'es')
    Suscribir::Suscripcion.suscribir(suscriptor, self, dominio_de_alta)
  end

  def desuscribe_a!(suscriptor, dominio_de_alta)
    busca_suscripcion(suscriptor, dominio_de_alta).destroy
  end
end
