require 'rails_helper'

describe Suscribir::Suscriptor do
  subject { create(:usuario) }
  let(:dominio_de_alta) { 'es' }
  let(:suscribible)  { create(:tematica) }

  describe "#busca_suscripcion" do
    context "sin ninguna suscripción" do
      it "debe devolver nil" do
        expect(subject.busca_suscripcion(suscribible, dominio_de_alta)).to be_nil
      end
    end

    context "con una suscripción" do
      before { subject.suscripciones << Suscribir::Suscripcion.create(suscribible: suscribible, email: subject.email) }

      it "debe devolver una suscripcion" do
        expect(subject.busca_suscripcion(suscribible, dominio_de_alta)).not_to be_nil
      end
    end
  end

  describe "#busca_suscripciones" do
    before { 2.times { create(:suscripcion, suscriptor: subject, dominio_de_alta: dominio_de_alta) } }

    context "sin ninguna suscripción" do
      it "debe devolver vacío" do
        expect(subject.busca_suscripciones('cl')).to be_empty
      end
    end

    context "con dos suscripciones" do
      it "debe devolver dos suscripciones" do
        expect(subject.busca_suscripciones(dominio_de_alta).size).to eq(2)
      end
    end
  end

  describe 'suscripciones relation' do
    before { create_list(:suscripcion, 3, suscriptor: subject) }

    describe 'delete_all' do
      it 'should delete instead of nullify them' do
        expect { subject.suscripciones.delete_all }.to change(Suscribir::Suscripcion, :count).from(3).to(0)
      end
    end
  end
end
