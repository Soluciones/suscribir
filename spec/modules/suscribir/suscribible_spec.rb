require 'rails_helper'

describe Suscribir::Suscribible do
  subject { Tematica.create }
  let(:dominio_de_alta) { 'es' }
  let(:suscriptor) { create(:usuario) }

  describe 'suscripciones_a_notificar' do
    let!(:suscripcion) { create(:suscripcion_con_suscriptor, suscriptor: suscriptor, suscribible: subject) }

    it 'devuelve las suscripciones a un suscribible' do
      expect(subject.suscripciones_a_notificar).to eq([suscripcion])
    end

    it 'permite excluir ciertos id de usuario' do
      expect(subject.suscripciones_a_notificar(excepto: suscriptor.id)).to eq([])
    end

    it 'no devuelve suscripciones de usuarios baneados' do
      allow_any_instance_of(Usuario).to receive(:emailable?).and_return(false)
      expect(subject.suscripciones_a_notificar).to eq([])
    end

    it 'devuelve suscripciones de usuarios no suscritos a alertas del foro' do
      allow_any_instance_of(Usuario).to receive(:foro_alertas).and_return(false)
      expect(subject.suscripciones_a_notificar).to eq([suscripcion])
    end
  end

  describe "#busca_suscripcion" do
    context "sin ninguna suscripción" do
      it "debe devolver nil" do
        expect(subject.busca_suscripcion(suscriptor, dominio_de_alta)).to be_nil
      end
    end

    context "con una suscripción" do
      before { create(:suscripcion_con_suscriptor, suscriptor: suscriptor, suscribible: subject) }

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
      before { 2.times { create(:suscripcion, suscribible: subject, dominio_de_alta: dominio_de_alta) } }

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
      before { allow(subject).to receive(:nombre).and_return(FFaker::Lorem.sentence) }

      it "da un nombre identificativo para la lista de suscriptores" do
        expect(subject.nombre_lista).to include subject.id.to_s
        expect(subject.nombre_lista).to include subject.class.name
        expect(subject.nombre_lista).to include subject.nombre
      end
    end
  end
end
