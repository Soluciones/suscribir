# coding: UTF-8

require "spec_helper"

describe Suscribir::SuscripcionAddToSendGridObserver do
  subject { described_class.new }
  let(:suscribible) do
    Tematica.create.tap do |tematica|
      tematica.stub(:nombre).and_return(Faker::Lorem.sentence)
    end
  end
  let(:suscripcion) { FactoryGirl.build(:suscripcion, suscribible: suscribible) }

  before(:each) do
    # Hacemos stub de todos los métodos para evitar llamadas reales a la API
    GatlingGun.any_instance.stub(:add_newsletter)
    GatlingGun.any_instance.stub(:add_list)
    GatlingGun.any_instance.stub(:add_email)
    GatlingGun.any_instance.stub(:add_recipient)
    GatlingGun.any_instance.stub(:add_schedule)
  end

  describe "#update" do
    context "al crear una suscripcion" do
      let(:nombre_lista) { "#{suscribible.nombre} (#{suscribible.class.model_name} id: #{suscribible.id})" }

      context "cuando la lista de suscriptores al suscribible no existe en SendGrid" do
        before do
          GatlingGun.any_instance.stub(:get_list).with(nombre_lista).and_return do
            double("Response").tap do |response|
              response.stub(:success?).and_return(false)
            end
          end
        end

        it "crea la lista" do
          GatlingGun.any_instance.should_receive(:add_list).with(nombre_lista)

          subject.update(:suscribir, suscripcion)
        end
      end

      context "cuando la lista de suscriptores al suscribible ya existe en SendGrid" do
        before do
          GatlingGun.any_instance.stub(:get_list).with(nombre_lista).and_return do
            double("Response").tap do |response|
              response.stub(:success?).and_return(true)
            end
          end
        end

        it "no crea la lista" do
          GatlingGun.any_instance.should_not_receive(:add_list).with(nombre_lista)

          subject.update(:suscribir, suscripcion)
        end
      end

      it "añade el suscriptor a la lista correspondiente de SendGrid" do
        GatlingGun.any_instance.should_receive(:add_email) do |_, suscriptor|
          suscriptor[:email].should == suscripcion.email
          suscriptor[:nombre_apellidos].should == suscripcion.nombre_apellidos
          suscriptor[:cod_postal].should == suscripcion.cod_postal
          suscriptor[:provincia_id].should == suscripcion.provincia_id
        end

        subject.update(:suscribir, suscripcion)
      end
    end

    context "al hacer algo que no observamos" do
      it "no hace nada" do
        GatlingGun.any_instance.should_not_receive(:add_list)
        GatlingGun.any_instance.should_not_receive(:add_email)

        subject.update(:no_me_observes, suscripcion)
      end
    end
  end
end
