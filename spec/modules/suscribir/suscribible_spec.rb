# coding: UTF-8

require "spec_helper"

describe Suscribir::Suscribible do
  subject { Tematica.create }
  let(:dominio_de_alta) { 'es' }
  let(:suscriptor) { FactoryGirl.create(:usuario) }


  describe "#busca_suscripcion" do
    context "sin ninguna suscripción" do
      it "debe devolver nil" do
        subject.busca_suscripcion(suscriptor, dominio_de_alta).should be_nil
      end
    end

    context "con una suscripción" do
      before { subject.suscripciones << Suscribir::Suscripcion.create(suscriptor: suscriptor, email: suscriptor.email) }

      it "debe devolver una suscripcion" do
        subject.busca_suscripcion(suscriptor, dominio_de_alta).should_not be_nil
      end
    end
  end

  describe "#suscribe_a!" do
    it "crea una suscripcion al suscribible" do
      subject.busca_suscripcion(suscriptor, dominio_de_alta).should be_nil

      subject.suscribe_a!(suscriptor, dominio_de_alta)

      subject.busca_suscripcion(suscriptor, dominio_de_alta).should_not be_nil
    end
  end
end
