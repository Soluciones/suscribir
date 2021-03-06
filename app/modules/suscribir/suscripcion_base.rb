module Suscribir
  module SuscripcionBase
    extend ActiveSupport::Concern

    included do

      enum procedencia: {
        todos: 'todos',
        blogs: 'blogs',
        foros: 'foros',
        videos: 'vídeos'
      }

      enum frecuencia: {
        inmediata: 'inmediata',
        diaria: 'diaria',
        semanal: 'semanal'
      }

      belongs_to :suscribible, polymorphic: true, counter_cache: :suscripciones_count
      belongs_to :suscriptor, polymorphic: true
      belongs_to :provincia

      delegate :nombre_suscripcion, to: :suscribible

      validates :suscribible_type, :suscribible_id, presence: true
      validates :dominio_de_alta, presence: true
      validates :email, presence: true, uniqueness: { scope: [:suscribible_type, :suscribible_id, :dominio_de_alta] }

      scope :activas, -> { where(activo: true) }
      scope :en_dominio, ->(dominio = nil) { where(dominio_de_alta: dominio) if dominio.present? }
      scope :sin_provincia, -> { where(provincia_id: nil) }
      scope :en_provincia_si_viene, ->(provincias_id) { where(provincia_id: provincias_id) if provincias_id.present? }
    end

    def token
      email_y_suscribible = "#{ email }#{ suscribible_type }#{ suscribible_id }"
      Digest::SHA1.hexdigest("#{ email_y_suscribible }#{ Rails.application.secrets.esta_web_secret_token }")
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
      rescue ActiveRecord::RecordNotUnique # only on race conditions should happen...
        busca_suscripcion(suscriptor, suscribible, dominio_de_alta)
      end

      def desuscribir(suscriptor, suscribible, dominio_de_alta = 'es')
        return desuscribir_multiples_suscribibles(suscriptor, suscribible, dominio_de_alta) if suscribible.respond_to?(:each)

        busca_suscripcion(suscriptor, suscribible, dominio_de_alta).try(:destroy)
      end

      def busca_suscripcion(suscriptor, suscribible, dominio_de_alta = 'es')
        email = suscriptor.respond_to?(:email) ? suscriptor.email : suscriptor

        where(email: email, suscribible_id: suscribible.id, suscribible_type: suscribible.class.name, dominio_de_alta: dominio_de_alta).first
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

      def desuscribir_multiples_suscribibles(suscriptor, suscribibles, dominio_de_alta = 'es')
        suscribibles.each_with_object([]) do |suscribible, suscripciones|
          suscripciones << desuscribir(suscriptor, suscribible, dominio_de_alta)
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
