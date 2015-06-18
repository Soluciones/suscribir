module Suscribir
  class SuscriptorAnonimo
    attr_accessor :email, :nombre_apellidos, :cod_postal, :provincia_id

    def initialize(email = nil, campos = {})
      self.email = email
      self.nombre_apellidos = campos[:nombre_apellidos]
      self.cod_postal = campos[:cod_postal]
      self.provincia_id = campos[:provincia_id]
    end

    def suscribeme_a!(suscribible, dominio_de_alta = 'es')
      Suscribir::Suscripcion.suscribir(self, suscribible, dominio_de_alta)
    end
  end
end
