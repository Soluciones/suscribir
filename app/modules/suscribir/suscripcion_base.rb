# coding: UTF-8

module Suscribir
  module SuscripcionBase
    extend ActiveSupport::Concern
    EVENTO_SUSCRIBIR = :suscribir

    included do
      belongs_to :suscribible, polymorphic: true
      belongs_to :suscriptor, polymorphic: true
      belongs_to :provincia

      validates :suscribible_type, :suscribible_id, presence: true
      validates :dominio_de_alta, presence: true
      validates :email, presence: true, uniqueness: { scope: [:suscribible_type, :suscribible_id, :dominio_de_alta] }
    end

    module ClassMethods
      def suscribir(suscriptor, suscribible, dominio_de_alta = 'es')
        atributos_del_suscriptor = dame_atributos_del_suscriptor(suscriptor)
        atributos_del_suscribible = { suscribible: suscribible, dominio_de_alta: dominio_de_alta }
        atributos_de_la_suscripcion = atributos_del_suscriptor.merge(atributos_del_suscribible)

        suscripcion = create(atributos_de_la_suscripcion)

        notify_observers(EVENTO_SUSCRIBIR, suscripcion) if suscripcion

        suscripcion
      end

    private

      def dame_atributos_del_suscriptor(suscriptor)
        {
          suscriptor: (suscriptor if suscriptor.is_a?(ActiveRecord::Base)),
          email: suscriptor.email,
          nombre_apellidos: suscriptor.nombre_apellidos,
          cod_postal: suscriptor.cod_postal,
          provincia_id: suscriptor.provincia_id
        }
      end
    end
  end
end
