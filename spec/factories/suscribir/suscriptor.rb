# coding: UTF-8

FactoryGirl.define do
  trait :suscriptor do
    email            { Faker::Internet.email }
    nombre_apellidos { Faker::Name.name }
    cod_postal       { Random.rand(10000..99999).to_s }
    provincia_id     { Random.rand(10..99) }
  end
end
