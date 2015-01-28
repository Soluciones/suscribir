require 'rails_helper'

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

  describe "#busca_suscripciones" do
    context "sin ninguna suscripción" do
      it "debe devolver vacío" do
        subject.busca_suscripciones(dominio_de_alta).should be_empty
      end
    end

    context "con dos suscripciones" do
      before { 2.times { FactoryGirl.create(:suscripcion, suscriptor: subject, dominio_de_alta: dominio_de_alta) } }

      it "debe devolver dos suscripciones" do
        subject.busca_suscripciones(dominio_de_alta).should have(2).suscripciones
      end
    end
  end
end
