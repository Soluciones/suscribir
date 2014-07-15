# coding: UTF-8

FactoryGirl.define do
  factory :newsletter, class: Suscribir::Newsletter do
    nombre { Faker::Lorem.words(2).join(' ') }
  end
end
