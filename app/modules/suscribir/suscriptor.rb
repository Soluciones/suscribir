# coding: UTF-8

require 'active_support/concern'

module Suscribir::Suscriptor
  extend ActiveSupport::Concern

  included do
    has_many :suscripciones, as: :suscriptor , class_name: 'Suscribir::Suscripcion'
  end

  def busca_suscripcion(suscribible, dominio_de_alta)
    suscripciones.where(suscribible_id: suscribible.id, suscribible_type: suscribible.class.model_name, dominio_de_alta: dominio_de_alta).first
  end

  def busca_suscripciones(dominio_de_alta)
    suscripciones.where(dominio_de_alta: dominio_de_alta)
  end

  def suscribeme_a!(suscribible, dominio_de_alta = 'es')
    suscripciones.create(email: email, suscribible_id: suscribible.id, suscribible_type: suscribible.class.model_name, dominio_de_alta: dominio_de_alta)
  end

  def desuscribeme_de!(suscribible, dominio_de_alta = 'es')
    busca_suscripcion(suscribible, dominio_de_alta).destroy
  end
end
