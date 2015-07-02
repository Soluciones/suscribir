require 'active_support/concern'

module Suscribir::Suscriptor
  extend ActiveSupport::Concern

  included do
    has_many :suscripciones, as: :suscriptor, class_name: 'Suscribir::Suscripcion', dependent: :delete_all
  end

  def busca_suscripcion(suscribible, dominio_de_alta)
    suscripciones.where(suscribible_id: suscribible.id, suscribible_type: suscribible.class.name, dominio_de_alta: dominio_de_alta).first
  end

  def busca_suscripciones(dominio_de_alta)
    suscripciones.where(dominio_de_alta: dominio_de_alta)
  end

  def suscribeme_a!(suscribible, dominio_de_alta = 'es')
    Suscribir::Suscripcion.suscribir(self, suscribible, dominio_de_alta)
  end

  def desuscribeme_de!(suscribible, dominio_de_alta = 'es')
    Suscribir::Suscripcion.desuscribir(self, suscribible, dominio_de_alta)
  end

  def suscrito_a?(suscribible)
    suscripciones.exists?(suscribible_id: suscribible.id, suscribible_type: suscribible.class.to_s)
  end

  def actualiza_suscripciones(clase, ids_seleccionadas)
    ids_ya_suscritas = ids_ya_suscritas(clase)
    suscribe_a_nuevas(clase, ids_seleccionadas, ids_ya_suscritas)
    desuscribe_ya_no_quiere(clase, ids_seleccionadas, ids_ya_suscritas)
  end

  def ids_ya_suscritas(tipo)
    suscripciones.where(suscribible_type: tipo, dominio_de_alta: I18n.locale).pluck(:suscribible_id)
  end

  private

  def suscribe_a_nuevas(clase_suscribible, ids_seleccionadas, ids_ya_suscritas)
    ids_nuevas = ids_seleccionadas - ids_ya_suscritas
    return if ids_nuevas.blank?
    suscribeme_a!(clase_suscribible.where(id: ids_nuevas), I18n.locale)
  end

  def desuscribe_ya_no_quiere(clase_suscribible, ids_seleccionadas, ids_ya_suscritas)
    ids_que_ya_no_quiere = ids_ya_suscritas - ids_seleccionadas
    return if ids_que_ya_no_quiere.blank?
    desuscribeme_de!(clase_suscribible.where(id: ids_que_ya_no_quiere), I18n.locale)
  end
end
