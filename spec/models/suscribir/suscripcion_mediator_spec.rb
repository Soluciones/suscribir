require 'rails_helper'

describe Suscribir::SuscripcionMediator do
  subject { Suscribir::SuscripcionMediator.instance }

  it "es un Rails observer" do
    expect(described_class).to respond_to :observe
  end

  it "debe ser observable" do
    expect(described_class).to respond_to :add_observer
    expect(described_class).to respond_to :notify_observers
  end

  describe "#after_create" do
    let(:suscripcion) { FactoryGirl.build(:suscripcion) }
    it "notifica a sus observadores con EVENTO_SUSCRIBIR" do
      expect(described_class).to receive(:notify_observers).with(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)

      subject.after_create(suscripcion)
    end
  end

  describe "#after_destroy" do
    let(:suscripcion) { FactoryGirl.build(:suscripcion) }
    it "notifica a sus observadores con EVENTO_DESUSCRIBIR" do
      expect(described_class).to receive(:notify_observers).with(Suscribir::SuscripcionMediator::EVENTO_DESUSCRIBIR, suscripcion)

      subject.after_destroy(suscripcion)
    end
  end
end
