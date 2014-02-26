# coding: UTF-8

require "spec_helper"

describe Suscribir::Suscriptor do
  subject { FactoryGirl.create(:usuario) }
  let(:dominio_de_alta) { 'es' }
  let(:suscribible)  { Tematica.create }


  describe "#busca_suscripcion" do
    context "sin ninguna suscripción" do
      it "debe devolver nil" do
        subject.busca_suscripcion(suscribible, dominio_de_alta).should be_nil
      end
    end

    context "con una suscripción" do
      before { subject.suscripciones << Suscribir::Suscripcion.create(suscribible: suscribible, email: subject.email) }

      it "debe devolver una suscripcion" do
        subject.busca_suscripcion(suscribible, dominio_de_alta).should_not be_nil
      end
    end
  end

  describe "#suscribeme_a!" do
    it "crea una suscripcion al suscriptor" do
      subject.busca_suscripcion(suscribible, dominio_de_alta).should be_nil

      subject.suscribeme_a!(suscribible, dominio_de_alta)

      subject.busca_suscripcion(suscribible, dominio_de_alta).should_not be_nil
    end
  end

  describe "#desuscribeme_de!" do
    context "con una suscripción" do
      before { subject.suscripciones << Suscribir::Suscripcion.create(suscribible: suscribible, email: subject.email) }

      it "elimina una suscripcion al suscriptor" do
        subject.busca_suscripcion(suscribible, dominio_de_alta).should_not be_nil

        subject.desuscribeme_de!(suscribible, dominio_de_alta)

        subject.busca_suscripcion(suscribible, dominio_de_alta).should be_nil
      end
    end
  end
end
