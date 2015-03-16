require 'rails_helper'

describe Suscribir::SuscripcionSyncSendGridObserver do
  subject { described_class.new }
  let(:nombre_lista) { FFaker::Lorem.sentence }
  let(:suscribible) do
    Tematica.create.tap do |tematica|
      allow(tematica).to receive(:nombre_lista) { nombre_lista }
    end
  end
  let(:suscripcion) { build(:suscripcion, suscribible: suscribible) }

  before(:each) do
    # Hacemos stub de todos los métodos para evitar llamadas reales a la API
    allow_any_instance_of(GatlingGun).to receive(:add_list)
    allow_any_instance_of(GatlingGun).to receive(:add_email)
    allow_any_instance_of(GatlingGun).to receive(:get_list) { GatlingGun::Response.new({}) }
    allow_any_instance_of(GatlingGun).to receive(:delete_email)
  end

  describe ".initialize" do

    context "si recibe un hash" do
      let(:acceso) { { user: FFaker::Internet.user_name, password: FFaker::Lorem.words(3).join } }

      it "lo usa como acceso para SendGrid" do
        expect(GatlingGun).to receive(:new).with(acceso[:user], acceso[:password]).and_call_original

        described_class.new(acceso)
      end
    end

    context "si recibe una instancia de GatlingGun" do
      let(:un_gatling_gun) { GatlingGun.new(FFaker::Internet.user_name, FFaker::Lorem.words(3).join) }

      it "la usa como conector para SendGrid" do
        instancia = described_class.new(un_gatling_gun)

        conector_interno = instancia.send(:sendgrid)
        expect(conector_interno).to eq(un_gatling_gun)
      end
    end

    context "si no recibe nada" do
      it "coge la configuración de la aplicación" do
        usuario = Rails.application.secrets.sendgrid_user_name
        password = Rails.application.secrets.sendgrid_password

        expect(GatlingGun).to receive(:new).with(usuario, password).and_call_original

        described_class.new
      end
    end
  end

  describe "#update" do
    context "al crear una suscripcion" do

      context "cuando la lista de suscriptores al suscribible no existe en SendGrid" do
        let(:respuesta) { GatlingGun::Response.new({}) }

        before do
          allow(respuesta).to receive(:error?) { true }
          allow_any_instance_of(GatlingGun).to receive(:get_list).with(nombre_lista) { respuesta }
        end

        it "crea la lista" do
          expect_any_instance_of(GatlingGun).to receive(:add_list).with(nombre_lista)
          subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)
        end
      end

      context "cuando la lista de suscriptores al suscribible ya existe en SendGrid" do
        let(:respuesta) { GatlingGun::Response.new({}) }

        before do
          allow(respuesta).to receive(:error?) { false }
          allow_any_instance_of(GatlingGun).to receive(:get_list).with(nombre_lista) { respuesta }
        end

        it "no crea la lista" do
          expect_any_instance_of(GatlingGun).not_to receive(:add_list).with(nombre_lista)
          subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)
        end
      end

      it "añade el suscriptor a la lista correspondiente de SendGrid" do
        expect_any_instance_of(GatlingGun).to receive(:add_email)
          .with(nombre_lista, email: suscripcion.email, name: suscripcion.nombre_apellidos)
        subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)
      end
    end

    context "al borrar una suscripcion" do
      it "borra el suscriptor de la lista correspondiente de SendGrid" do
        expect_any_instance_of(GatlingGun).to receive(:delete_email).with(nombre_lista, suscripcion.email)
        subject.update(Suscribir::SuscripcionMediator::EVENTO_DESUSCRIBIR, suscripcion)
      end
    end

    context "al hacer algo que no observamos" do
      it "no hace nada" do
        expect_any_instance_of(GatlingGun).not_to receive(:add_list)
        expect_any_instance_of(GatlingGun).not_to receive(:add_email)
        expect_any_instance_of(GatlingGun).not_to receive(:delete_email)

        subject.update(:no_me_observes, suscripcion)
      end
    end
  end
end
