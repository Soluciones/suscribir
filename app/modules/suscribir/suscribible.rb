require 'active_support/concern'

module Suscribir::Suscribible
  extend ActiveSupport::Concern

  included do
    has_many :suscripciones, as: :suscribible , class_name: 'Suscribir::Suscripcion'
    has_many :suscriptores, through: :suscripciones, source_type: 'Usuario'
    has_many :newsletters, as: :suscribible, class_name: 'NewsTematica::NewsTematica'

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

  def suscripciones_a_notificar(opciones = {})
    todas = suscripciones.activas.where.not(suscriptor_id: opciones[:excepto]).includes(:suscriptor).to_a
    # Queremos que se envíe a los suscriptores que no responden a emailable? (suscritos por captador)
    todas.delete_if do |suscripcion|
      suscripcion.suscriptor.respond_to?(:emailable?) && !suscripcion.suscriptor.emailable?
    end
  end

  def nombre_suscripcion
    try(:nombre) || try(:titulo)
  end

  def cookie_key
    "no_mostrar-#{ id_y_clase }"
  end

  def id_y_clase
    "#{ id }-#{ self.class }"
  end
end
