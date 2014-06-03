# coding: UTF-8

require "spec_helper"

describe Suscribir::SuscripcionSetUserIfFoundObserver do
  subject { described_class.new }
  let(:suscribible) do
    Tematica.create.tap do |tematica|
      tematica.stub(:nombre).and_return(Faker::Lorem.sentence)
    end
  end
  let(:suscripcion) { FactoryGirl.build(:suscripcion, suscribible: suscribible) }

  describe "#update" do
    def no_hace_nada
      suscripcion.suscriptor_id.should be_nil
      suscripcion.suscriptor_type.should be_nil
    end

    context "al crear una suscripcion" do
      context "con un email que ya tenemos registrado como usuario" do
        let!(:usuario) { Usuario.create(email: suscripcion.email) }

        it "le asigna el usuario a la suscripción" do
          subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)

          suscripcion.suscriptor_id.should == usuario.id
          suscripcion.suscriptor_type.should == usuario.class.name
        end
      end

      context "con un email que no tenemos registrado como usuario" do
        it "no hace nada" do
          subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)

          no_hace_nada
        end
      end

    end

    context "al hacer algo que no observamos" do
      it "no hace nada" do
        subject.update(:no_me_observes, suscripcion)

        no_hace_nada
      end
    end
  end
end
