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
    return suscribe_a_multiple!(suscriptor, dominio_de_alta) if suscriptor.respond_to?(:each)
    suscripciones.create(suscriptor: suscriptor, email: suscriptor.email, dominio_de_alta: dominio_de_alta)
  end

  def desuscribe_a!(suscriptor, dominio_de_alta)
    busca_suscripcion(suscriptor, dominio_de_alta).destroy
  end

private

  def suscribe_a_multiple!(suscriptores, dominio_de_alta = 'es')
    suscriptores.each_with_object([]) do |suscriptor, suscripciones|
      suscripciones << suscribe_a!(suscriptor, dominio_de_alta)
    end
  end
end
