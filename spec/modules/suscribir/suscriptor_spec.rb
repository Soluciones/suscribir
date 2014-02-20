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
end
