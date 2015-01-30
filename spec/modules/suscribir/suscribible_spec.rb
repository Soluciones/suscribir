require 'rails_helper'

describe Suscribir::Suscribible do
  subject { Tematica.create }
  let(:dominio_de_alta) { 'es' }
  let(:suscriptor) { FactoryGirl.create(:usuario) }


  describe "#busca_suscripcion" do
    context "sin ninguna suscripción" do
      it "debe devolver nil" do
        expect(subject.busca_suscripcion(suscriptor, dominio_de_alta)).to be_nil
      end
    end

    context "con una suscripción" do
      before { subject.suscripciones << Suscribir::Suscripcion.create(suscriptor: suscriptor, email: suscriptor.email) }

      it "debe devolver una suscripcion" do
        expect(subject.busca_suscripcion(suscriptor, dominio_de_alta)).to be_present
      end
    end
  end

  describe "#busca_suscripciones" do
    context "sin ninguna suscripción" do
      it "debe devolver vacío" do
        expect(subject.busca_suscripciones(dominio_de_alta)).to be_empty
      end
    end

    context "con dos suscripciones" do
      before { 2.times { FactoryGirl.create(:suscripcion, suscribible: subject, dominio_de_alta: dominio_de_alta) } }

      it "debe devolver dos suscripciones" do
        expect(subject.busca_suscripciones(dominio_de_alta).size).to eq(2)
      end
    end
  end

  describe "#nombre_lista" do
    context "con un suscribible sin nombre" do
      it "da un nombre identificativo para la lista de suscriptores" do
        expect(subject.nombre_lista).to include subject.id.to_s
        expect(subject.nombre_lista).to include subject.class.name
      end
    end

    context "con un suscribible con nombre" do
      before { subject.stub(nombre: Faker::Lorem.sentence) }

      it "da un nombre identificativo para la lista de suscriptores" do
        expect(subject.nombre_lista).to include subject.id.to_s
        expect(subject.nombre_lista).to include subject.class.name
        expect(subject.nombre_lista).to include subject.nombre
      end
    end
  end
end
