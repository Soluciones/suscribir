# coding: UTF-8

module Suscribir
  class SuscriptorAnonimo
    attr_accessor :email, :nombre_apellidos, :cod_postal, :provincia_id

    def initialize(email = nil)
      self.email = email
    end

    def suscribeme_a!(suscribible, dominio_de_alta = 'es')
      Suscribir::Suscripcion.suscribir(self, suscribible, dominio_de_alta)
    end
  end
end
