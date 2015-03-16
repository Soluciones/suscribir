# coding: UTF-8

FactoryGirl.define do
  factory :newsletter, class: Suscribir::Newsletter do
    nombre { FFaker::Lorem.words(2).join(' ') }
  end
end
