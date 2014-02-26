# coding: UTF-8

require "spec_helper"

describe Suscribir::SuscripcionDeleteFromSendGridObserver do
  subject { described_class.new }
  let(:suscribible) do
    Tematica.create.tap do |tematica|
      tematica.stub(:nombre).and_return(Faker::Lorem.sentence)
    end
  end
  let(:suscripcion) { FactoryGirl.build(:suscripcion, suscribible: suscribible) }

  before(:each) do
    # Hacemos stub de todos los métodos para evitar llamadas reales a la API
    GatlingGun.any_instance.stub(:delete_email)
  end

  describe ".initialize" do

    context "si recibe un hash" do
      let(:acceso) { { user: Faker::Internet.user_name, password: Faker::Lorem.words(3).join } }

      it "lo usa como acceso para SendGrid" do
        GatlingGun.should_receive(:new).with(acceso[:user], acceso[:password]).and_call_original

        described_class.new(acceso)
      end
    end

    context "si recibe una instancia de GatlingGun" do
      let(:un_gatling_gun) { GatlingGun.new(Faker::Internet.user_name, Faker::Lorem.words(3).join) }

      it "la usa como conector para SendGrid" do
        instancia = described_class.new(un_gatling_gun)

        conector_interno = instancia.send(:sendgrid)
        conector_interno.should == un_gatling_gun
      end
    end

    context "si no recibe nada" do
      it "coge la configuración de la aplicación" do
        usuario = Rails.application.class::ENV_CONFIG["SENDGRID_USER_NAME"]
        password = Rails.application.class::ENV_CONFIG["SENDGRID_PASSWORD"]

        GatlingGun.should_receive(:new).with(usuario, password).and_call_original

        described_class.new
      end
    end
  end

  describe "#update" do
    context "al borrar una suscripcion" do
      let(:nombre_lista) { "#{suscribible.nombre} (#{suscribible.class.model_name} id: #{suscribible.id})" }

      it "borra el suscriptor de la lista correspondiente de SendGrid" do
        GatlingGun.any_instance.should_receive(:delete_email) do |nombre_lista_recibido, email|
          nombre_lista_recibido.should == nombre_lista
          email.should == suscripcion.email
        end

        subject.update(Suscribir::Suscripcion::EVENTO_DESUSCRIBIR, suscripcion)
      end
    end

    context "al hacer algo que no observamos" do
      it "no hace nada" do
        GatlingGun.any_instance.should_not_receive(:delete_email)

        subject.update(:no_me_observes, suscripcion)
      end
    end
  end
end
