require 'rails_helper'

describe Suscribir::Suscribible do
  subject { create(:tematica) }
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

    it 'devuelve las suscripciones de usuarios suscritos por captador (no registrados)' do
      # Los suscriptores por captador no tienen emailable? definido.
      expect_any_instance_of(Usuario).to receive(:respond_to?).with(:emailable?).and_return(false)
      expect(subject.suscripciones_a_notificar).to eq([suscripcion])
    end

    it 'no devuelve suscripciones de usuarios baneados' do
      expect_any_instance_of(Usuario).to receive(:emailable?).and_return(false)
      expect(subject.suscripciones_a_notificar).to eq([])
    end

    it 'no devuelve las suscripciones no activas' do
      suscripcion.update_attribute(:activo, false)
      expect(subject.suscripciones_a_notificar).not_to match_array([suscripcion])
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
end
