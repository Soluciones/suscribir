# coding: UTF-8

require "spec_helper"

describe Suscribir::Suscripcion do
  let(:dominio_de_alta) { 'es' }
  let(:suscribible) { Tematica.create }

  it "debe ser observable" do
    described_class.should respond_to :add_observer
  end

  describe ".suscribir" do
    shared_examples "suscripcion copiando datos" do
      it "rellena el email" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.email.should == suscriptor.email
      end

      it "rellena nombre_apellidos, cod_postal y provincia_id" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.nombre_apellidos.should == suscriptor.nombre_apellidos
        suscripcion.cod_postal.should == suscriptor.cod_postal
        suscripcion.provincia_id.should == suscriptor.provincia_id
      end
    end

    context "para un suscriptor persistido (p.ej.: Usuario)" do
      let(:suscriptor) { FactoryGirl.create(:usuario) }

      it_behaves_like "suscripcion copiando datos"

      it "crea una suscripción relacionada a un Suscriptor" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.suscriptor.should_not be_nil
        suscripcion.suscriptor_id.should == suscriptor.id
        suscripcion.suscriptor_type.should == suscriptor.class.model_name
      end
    end

    context "para un suscriptor no persistido o anónimo" do
      let(:suscriptor) { FactoryGirl.build(:suscriptor_anonimo) }

      it_behaves_like "suscripcion copiando datos"

      it "crea una suscripción no relacionada a un Suscriptor" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.suscriptor.should be_nil
      end
    end
  end
end
