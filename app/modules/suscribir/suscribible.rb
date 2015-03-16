require 'active_support/concern'

module Suscribir::Suscribible
  extend ActiveSupport::Concern

  included do
    has_many :suscripciones, as: :suscribible , class_name: 'Suscribir::Suscripcion'
    has_many :suscriptores, through: :suscripciones, source_type: 'Usuario'

    delegate :activas, to: :suscripciones, prefix: true
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
    Suscribir::Suscripcion.desuscribir(suscriptor, self, dominio_de_alta)
  end

  def nombre_lista
    "#{self.class.name} id: #{id}#{ " (#{nombre})" if respond_to?(:nombre) }"
  end

  def suscripciones_a_notificar(opciones = {})
    todas = suscripciones.activas.where.not(suscriptor_id: opciones[:excepto]).includes(:suscriptor).to_a
    todas.select { |suscripcion| suscripcion.suscriptor.try(:emailable?) }
  end

  def nombre_suscripcion
    try(:nombre) || try(:titulo)
  end
end
