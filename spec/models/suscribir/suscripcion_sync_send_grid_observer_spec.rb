require 'rails_helper'

describe Suscribir::SuscripcionSyncSendGridObserver do
  subject { described_class.new }
  let(:nombre_lista) { Faker::Lorem.sentence }
  let(:suscribible) do
    Tematica.create.tap do |tematica|
      allow(tematica).to receive(:nombre_lista).with(nombre_lista)
    end
  end
  let(:suscripcion) { FactoryGirl.build(:suscripcion, suscribible: suscribible) }

  before(:each) do
    # Hacemos stub de todos los métodos para evitar llamadas reales a la API
    allow_any_instance_of(GatlingGun).to receive(:add_list)
    allow_any_instance_of(GatlingGun).to receive(:add_email)
    allow_any_instance_of(GatlingGun).to receive(:get_list).and_return(GatlingGun::Response.new({}))
    allow_any_instance_of(GatlingGun).to receive(:delete_email)
  end

  describe ".initialize" do

    context "si recibe un hash" do
      let(:acceso) { { user: Faker::Internet.user_name, password: Faker::Lorem.words(3).join } }

      it "lo usa como acceso para SendGrid" do
        expect(GatlingGun).to receive(:new).with(acceso[:user], acceso[:password]).and_call_original

        described_class.new(acceso)
      end
    end

    context "si recibe una instancia de GatlingGun" do
      let(:un_gatling_gun) { GatlingGun.new(Faker::Internet.user_name, Faker::Lorem.words(3).join) }

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
        before do
          allow_any_instance_of(GatlingGun).to receive(:get_list).with(nombre_lista).and_return do
            double("Response").tap do |response|
              allow(response).to receive(:error?).and_return(true)
            end
          end
        end

        it "crea la lista" do
          expect_any_instance_of(GatlingGun).to receive(:add_list).with(nombre_lista)

          subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)
        end
      end

      context "cuando la lista de suscriptores al suscribible ya existe en SendGrid" do
        before do
          allow_any_instance_of(GatlingGun).to receive(:get_list).with(nombre_lista).and_return do
            double("Response").tap do |response|
              allow(response).to receive(:error?).and_return(false)
            end
          end
        end

        it "no crea la lista" do
          expect_any_instance_of(GatlingGun).not_to receive(:add_list).with(nombre_lista)

          subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)
        end
      end

      it "añade el suscriptor a la lista correspondiente de SendGrid" do
        expect_any_instance_of(GatlingGun).to receive(:add_email) do |nombre_lista_recibido, suscriptor|
          expect(nombre_lista_recibido).to eq(nombre_lista)
          expect(suscriptor[:email]).to eq(suscripcion.email)
          expect(suscriptor[:name]).to eq(suscripcion.nombre_apellidos)
        end

        subject.update(Suscribir::SuscripcionMediator::EVENTO_SUSCRIBIR, suscripcion)
      end
    end

    context "al borrar una suscripcion" do
      it "borra el suscriptor de la lista correspondiente de SendGrid" do
        expect_any_instance_of(GatlingGun).to receive(:delete_email) do |nombre_lista_recibido, email|
          expect(nombre_lista_recibido).to eq(nombre_lista)
          expect(email).to eq(suscripcion.email)
        end

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
