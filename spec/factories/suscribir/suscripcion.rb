# coding: UTF-8

FactoryGirl.define do
  factory :suscripcion, class: Suscribir::Suscripcion do
    suscriptor
    association :suscribible, factory: :tematica

    factory :suscripcion_con_suscriptor do
      association :suscriptor, factory: :usuario

      after(:build) do |suscripcion|
        suscriptor = suscripcion.suscriptor

        suscripcion.email = suscriptor.email
        suscripcion.nombre_apellidos = suscriptor.nombre_apellidos
        suscripcion.cod_postal = suscriptor.cod_postal
        suscripcion.provincia_id = suscriptor.provincia_id
      end
    end
  end
end
