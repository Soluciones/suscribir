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

  describe "#suscribeme_a!" do
    context "pasando un suscribible" do
      it "crea una suscripcion al suscriptor" do
        subject.busca_suscripcion(suscribible, dominio_de_alta).should be_nil

        subject.suscribeme_a!(suscribible, dominio_de_alta)

        subject.busca_suscripcion(suscribible, dominio_de_alta).should_not be_nil
      end
    end

    context "pasando un array de suscribibles" do
      let(:suscribibles) { FactoryGirl.create_list(:tematica, 3) }

      it "crea multiples suscripciones" do
        subject.suscribeme_a!(suscribibles, dominio_de_alta)

        subject.suscripciones.map(&:suscribible_id).should =~ suscribibles.map(&:id)
      end

      it "devuelve las suscripciones creadas" do
        suscripciones_creadas = subject.suscribeme_a!(suscribibles, dominio_de_alta)

        suscripciones_encontradas = subject.busca_suscripciones(dominio_de_alta)

        suscripciones_creadas.map(&:id).should =~ suscripciones_encontradas.map(&:id)
      end
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
