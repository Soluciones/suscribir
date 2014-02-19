# coding: UTF-8

require 'active_support/concern'

module Suscribir::Suscriptor
  extend ActiveSupport::Concern

  included do
    has_many :suscripciones, as: :suscriptor , class_name: 'Suscribir::Suscripcion'
  end
end
