# coding: UTF-8

FactoryGirl.define do
  factory :suscripcion, class: Suscribir::Suscripcion do
    suscriptor
    suscriptor_id nil
    suscriptor_type nil
  end
end
