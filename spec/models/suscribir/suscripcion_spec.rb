# coding: UTF-8

require "spec_helper"

describe Suscribir::Suscripcion do
  let(:dominio_de_alta) { 'es' }
  let(:suscribible) { Tematica.create }

  it "debe ser observable" do
    described_class.should respond_to :add_observer
  end

  describe ".suscribir" do
    shared_examples "suscripcion copiando datos" do
      it "rellena el email" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.email.should == suscriptor.email
      end

      it "rellena nombre_apellidos, cod_postal y provincia_id" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.nombre_apellidos.should == suscriptor.nombre_apellidos
        suscripcion.cod_postal.should == suscriptor.cod_postal
        suscripcion.provincia_id.should == suscriptor.provincia_id
      end
    end

    shared_examples "suscripcion multiple" do
      context "pasando un array de suscribibles" do
        let(:suscribibles) { FactoryGirl.create_list(:tematica, 3) }

        it "crea multiples suscripciones" do
          described_class.suscribir(suscriptor, suscribibles, dominio_de_alta)

          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)

          suscripciones_encontradas.map(&:suscribible_id).should =~ suscribibles.map(&:id)
          suscripciones_encontradas.all?{ |s| s.email == suscriptor.email }.should be_true
        end

        it "devuelve las suscripciones creadas" do
          suscripciones_creadas = described_class.suscribir(suscriptor, suscribibles, dominio_de_alta)

          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)

          suscripciones_creadas.map(&:id).should =~ suscripciones_encontradas.map(&:id)
        end
      end

      context "pasando un array de suscriptores" do
        let(:suscriptores) { FactoryGirl.create_list(:usuario, 3) }

        it "crea multiples suscripciones" do
          described_class.suscribir(suscriptores, suscribible, dominio_de_alta)

          suscripciones_encontradas = described_class.where(suscribible_id: suscribible, suscribible_type: suscribible.class.model_name, dominio_de_alta: dominio_de_alta)

          suscripciones_encontradas.map(&:email).should =~ suscriptores.map(&:email)
          suscripciones_encontradas.all?{ |s| s.suscribible_id == suscribible.id }.should be_true
        end

        it "devuelve las suscripciones creadas" do
          suscripciones_creadas = described_class.suscribir(suscriptores, suscribible, dominio_de_alta)

          suscripciones_encontradas = described_class.where(suscribible_id: suscribible, suscribible_type: suscribible.class.model_name, dominio_de_alta: dominio_de_alta)

          suscripciones_creadas.map(&:id).should =~ suscripciones_encontradas.map(&:id)
        end
      end

      context "intentando crear una suscripcion duplicada" do
        let!(:suscripcion_existente) { FactoryGirl.create(:suscripcion_con_suscriptor) }

        it "devuleve la suscripción original" do
          suscripcion_devuleta = described_class.suscribir(suscripcion_existente.suscriptor, suscripcion_existente.suscribible, suscripcion_existente.dominio_de_alta)
          suscripcion_devuleta.id.should == suscripcion_existente.id
        end
      end
    end

    context "para un suscriptor persistido (p.ej.: Usuario)" do
      let(:suscriptor) { FactoryGirl.create(:usuario) }

      it_behaves_like "suscripcion copiando datos"
      it_behaves_like "suscripcion multiple"

      it "crea una suscripción relacionada a un Suscriptor" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.suscriptor.should_not be_nil
        suscripcion.suscriptor_id.should == suscriptor.id
        suscripcion.suscriptor_type.should == suscriptor.class.model_name
      end
    end

    context "para un suscriptor no persistido o anónimo" do
      let(:suscriptor) { FactoryGirl.build(:suscriptor_anonimo) }

      it_behaves_like "suscripcion copiando datos"
      it_behaves_like "suscripcion multiple"

      it "crea una suscripción no relacionada a un Suscriptor" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        suscripcion.suscriptor.should be_nil
      end
    end
  end

  describe ".busca_suscripcion" do
    context "con una suscripción" do
      let!(:suscripcion) { FactoryGirl.create(:suscripcion) }

      context "pasando un email" do
        it "encuentra la suscripción a partir del email, suscribible y dominio" do
          described_class.busca_suscripcion(suscripcion.email, suscripcion.suscribible, suscripcion.dominio_de_alta).should_not be_nil
        end
      end

      context "pasando un suscriptor" do
        let!(:suscripcion) { FactoryGirl.create(:suscripcion_con_suscriptor) }

        it "encuentra la suscripción a partir del suscriptor, suscribible y dominio" do
          described_class.busca_suscripcion(suscripcion.suscriptor, suscripcion.suscribible, suscripcion.dominio_de_alta).should_not be_nil
        end
      end
    end
  end

  describe ".busca_suscripciones" do
    let!(:suscripciones) { FactoryGirl.create_list(:suscripcion, 2, email: suscriptor.email, dominio_de_alta: dominio_de_alta) }

    context "con dos suscripciones del mismo suscriptor" do
      context "pasando un email y un dominio" do
        let(:suscriptor) { FactoryGirl.build(:suscriptor_anonimo) }
        it "encuentra las suscripciones" do
          described_class.busca_suscripciones(suscriptor.email, dominio_de_alta).should have(2).suscripciones
        end
      end

      context "pasando un suscriptor y un dominio" do
        let(:suscriptor) { FactoryGirl.create(:usuario) }
        it "encuentra las suscripciones" do
          described_class.busca_suscripciones(suscriptor.email, dominio_de_alta).should have(2).suscripciones
        end
      end
    end
  end

  describe ".desuscribir" do
    context "pasando un email" do
      context "con una suscripción" do
        let!(:suscripcion) { FactoryGirl.create(:suscripcion) }
        it "elimina la suscripción a partir del email, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: suscripcion.email, suscribible_id: suscripcion.suscribible.id, suscribible_type: suscripcion.suscribible.class.model_name, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should_not be_empty

          described_class.desuscribir(suscripcion.email, suscripcion.suscribible, suscripcion.dominio_de_alta).should_not be_nil

          suscripciones_encontradas = described_class.where(email: suscripcion.email, suscribible_id: suscripcion.suscribible.id, suscribible_type: suscripcion.suscribible.class.model_name, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should be_empty
        end
      end

      context "con varias suscripciones" do
        let(:email) { Faker::Internet.email }
        let!(:suscripciones) { FactoryGirl.create_list(:suscripcion, 3, email: email, dominio_de_alta: dominio_de_alta) }

        it "elimina las suscripciones a partir del email, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: email, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should_not be_empty

          described_class.desuscribir(email, suscripciones.map(&:suscribible), dominio_de_alta).should_not be_nil

          suscripciones_encontradas = described_class.where(email: email, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should be_empty
        end
      end
    end

    context "pasando un suscriptor" do
      context "con una suscripción" do
        let!(:suscripcion) { FactoryGirl.create(:suscripcion_con_suscriptor) }

        it "elimina la suscripción a partir del suscriptor, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: suscripcion.email, suscribible_id: suscripcion.suscribible.id, suscribible_type: suscripcion.suscribible.class.model_name, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should_not be_empty

          described_class.desuscribir(suscripcion.suscriptor, suscripcion.suscribible, suscripcion.dominio_de_alta).should_not be_nil

          suscripciones_encontradas = described_class.where(email: suscripcion.email, suscribible_id: suscripcion.suscribible.id, suscribible_type: suscripcion.suscribible.class.model_name, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should be_empty
        end
      end

      context "con varias suscripciones" do
        let(:suscriptor) { FactoryGirl.create(:usuario) }
        let!(:suscripciones) { FactoryGirl.create_list(:suscripcion_con_suscriptor, 3, suscriptor: suscriptor, dominio_de_alta: dominio_de_alta) }

        it "elimina las suscripciones a partir del email, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should_not be_empty

          described_class.desuscribir(suscriptor, suscripciones.map(&:suscribible), dominio_de_alta).should_not be_nil

          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)
          suscripciones_encontradas.should be_empty
        end
      end
    end
  end

  describe "#nombre_lista" do
    subject { FactoryGirl.create(:suscripcion) }

    it "delega el método a su suscribible" do
      subject.nombre_lista.should == subject.suscribible.nombre_lista
    end
  end
end
