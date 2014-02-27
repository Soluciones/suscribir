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

  describe "#busca_suscripciones" do
    context "sin ninguna suscripción" do
      it "debe devolver vacío" do
        subject.busca_suscripciones(dominio_de_alta).should be_empty
      end
    end

    context "con dos suscripciones" do
      before { 2.times { FactoryGirl.create(:suscripcion, suscribible: subject, dominio_de_alta: dominio_de_alta) } }

      it "debe devolver dos suscripciones" do
        subject.busca_suscripciones(dominio_de_alta).should have(2).suscripciones
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

  describe "#desuscribe_a!" do
    context "con una suscripción" do
      before { subject.suscripciones << Suscribir::Suscripcion.create(suscriptor: suscriptor, email: suscriptor.email) }

      it "elimina una suscripcion al suscriptor" do
        subject.busca_suscripcion(suscriptor, dominio_de_alta).should_not be_nil

        subject.desuscribe_a!(suscriptor, dominio_de_alta)

        subject.busca_suscripcion(suscriptor, dominio_de_alta).should be_nil
      end
    end
  end
end
