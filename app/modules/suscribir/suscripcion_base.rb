# coding: UTF-8

module Suscribir
  module SuscripcionBase
    extend ActiveSupport::Concern

    included do
      belongs_to :suscribible, polymorphic: true
      belongs_to :suscriptor, polymorphic: true
      belongs_to :provincia

      delegate :nombre_lista, to: :suscribible

      validates :suscribible_type, :suscribible_id, presence: true
      validates :dominio_de_alta, presence: true
      validates :email, presence: true, uniqueness: { scope: [:suscribible_type, :suscribible_id, :dominio_de_alta] }
    end

    module ClassMethods
      def suscribir(suscriptor, suscribible, dominio_de_alta = 'es')
        return suscribir_multiples_suscribibles(suscriptor, suscribible, dominio_de_alta) if suscribible.respond_to?(:each)
        return suscribir_multiples_suscriptores(suscriptor, suscribible, dominio_de_alta) if suscriptor.respond_to?(:each)

        if suscripcion_existente = busca_suscripcion(suscriptor, suscribible, dominio_de_alta)
          return suscripcion_existente
        end

        atributos_del_suscriptor = dame_atributos_del_suscriptor(suscriptor)
        atributos_del_suscribible = { suscribible: suscribible, dominio_de_alta: dominio_de_alta }
        atributos_de_la_suscripcion = atributos_del_suscriptor.merge(atributos_del_suscribible)

        create(atributos_de_la_suscripcion)
      end

      def desuscribir(suscriptor, suscribible, dominio_de_alta = 'es')
        busca_suscripcion(suscriptor, suscribible, dominio_de_alta).destroy
      end

      def busca_suscripcion(suscriptor, suscribible, dominio_de_alta = 'es')
        email = suscriptor.respond_to?(:email) ? suscriptor.email : suscriptor

        where(email: email, suscribible_id: suscribible.id, suscribible_type: suscribible.class.model_name, dominio_de_alta: dominio_de_alta).first
      end

      def busca_suscripciones(suscriptor, dominio_de_alta = 'es')
        email = suscriptor.respond_to?(:email) ? suscriptor.email : suscriptor

        where(email: email, dominio_de_alta: dominio_de_alta)
      end

    private

      def suscribir_multiples_suscribibles(suscriptor, suscribibles, dominio_de_alta = 'es')
        suscribibles.each_with_object([]) do |suscribible, suscripciones|
          suscripciones << suscribir(suscriptor, suscribible, dominio_de_alta)
        end
      end

      def suscribir_multiples_suscriptores(suscriptores, suscribible, dominio_de_alta = 'es')
        suscriptores.each_with_object([]) do |suscriptor, suscripciones|
          suscripciones << suscribir(suscriptor, suscribible, dominio_de_alta)
        end
      end

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
