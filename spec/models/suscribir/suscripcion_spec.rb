require 'rails_helper'

describe Suscribir::Suscripcion do
  let(:dominio_de_alta) { 'es' }
  let(:suscribible) { create(:tematica) }

  it "debe ser observable" do
    expect(described_class).to respond_to :add_observer
  end

  describe ".suscribir" do
    shared_examples "suscripcion copiando datos" do
      it "rellena el email" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        expect(suscripcion.email).to eq(suscriptor.email)
      end

      it "rellena nombre_apellidos, cod_postal y provincia_id" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        expect(suscripcion.nombre_apellidos).to eq(suscriptor.nombre_apellidos)
        expect(suscripcion.cod_postal).to eq(suscriptor.cod_postal)
        expect(suscripcion.provincia_id).to eq(suscriptor.provincia_id)
      end
    end

    shared_examples "suscripcion multiple" do
      context "pasando un array de suscribibles" do
        let(:suscribibles) { create_list(:tematica, 3) }

        it "crea multiples suscripciones" do
          described_class.suscribir(suscriptor, suscribibles, dominio_de_alta)

          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)

          expect(suscripciones_encontradas.map(&:suscribible_id)).to match_array(suscribibles.map(&:id))
          expect(suscripciones_encontradas.all? { |s| s.email == suscriptor.email }).to be_truthy
        end

        it "devuelve las suscripciones creadas" do
          suscripciones_creadas = described_class.suscribir(suscriptor, suscribibles, dominio_de_alta)

          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)

          expect(suscripciones_creadas.map(&:id)).to match_array(suscripciones_encontradas.map(&:id))
        end
      end

      context "pasando un array de suscriptores" do
        let(:suscriptores) { create_list(:usuario, 3) }

        it "crea multiples suscripciones" do
          described_class.suscribir(suscriptores, suscribible, dominio_de_alta)

          suscripciones_encontradas = described_class.where(suscribible_id: suscribible, suscribible_type: suscribible.class.name, dominio_de_alta: dominio_de_alta)

          expect(suscripciones_encontradas.map(&:email)).to match_array(suscriptores.map(&:email))
          expect(suscripciones_encontradas.all? { |s| s.suscribible_id == suscribible.id }).to be_truthy
        end

        it "devuelve las suscripciones creadas" do
          suscripciones_creadas = described_class.suscribir(suscriptores, suscribible, dominio_de_alta)

          suscripciones_encontradas = described_class.where(suscribible_id: suscribible, suscribible_type: suscribible.class.name, dominio_de_alta: dominio_de_alta)

          expect(suscripciones_creadas.map(&:id)).to match_array(suscripciones_encontradas.map(&:id))
        end
      end

      context "intentando crear una suscripcion duplicada" do
        let!(:suscripcion_existente) { create(:suscripcion_con_suscriptor) }

        it "devuleve la suscripción original" do
          suscripcion_devuleta = described_class.suscribir(suscripcion_existente.suscriptor, suscripcion_existente.suscribible, suscripcion_existente.dominio_de_alta)
          expect(suscripcion_devuleta.id).to eq(suscripcion_existente.id)
        end
      end
    end

    context "para un suscriptor persistido (p.ej.: Usuario)" do
      let(:suscriptor) { create(:usuario) }

      it_behaves_like "suscripcion copiando datos"
      it_behaves_like "suscripcion multiple"

      it "crea una suscripción relacionada a un Suscriptor" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        expect(suscripcion.suscriptor).to be_present
        expect(suscripcion.suscriptor_id).to eq(suscriptor.id)
        expect(suscripcion.suscriptor_type).to eq(suscriptor.class.name)
      end
    end

    context "para un suscriptor no persistido o anónimo" do
      let(:suscriptor) { build(:suscriptor_anonimo) }

      it_behaves_like "suscripcion copiando datos"
      it_behaves_like "suscripcion multiple"

      it "crea una suscripción no relacionada a un Suscriptor" do
        suscripcion = described_class.suscribir(suscriptor, suscribible)

        expect(suscripcion.suscriptor).to be_nil
      end
    end
  end

  describe ".busca_suscripcion" do
    context "con una suscripción" do
      let!(:suscripcion) { create(:suscripcion) }

      context "pasando un email" do
        it "encuentra la suscripción a partir del email, suscribible y dominio" do
          params = suscripcion.email, suscripcion.suscribible, suscripcion.dominio_de_alta
          expect(described_class.busca_suscripcion(*params)).to be_present
        end
      end

      context "pasando un suscriptor" do
        let!(:suscripcion) { create(:suscripcion_con_suscriptor) }

        it "encuentra la suscripción a partir del suscriptor, suscribible y dominio" do
          params = suscripcion.suscriptor, suscripcion.suscribible, suscripcion.dominio_de_alta
          expect(described_class.busca_suscripcion(*params)).to be_present
        end
      end
    end
  end

  describe ".busca_suscripciones" do
    let!(:suscripciones) { create_list(:suscripcion, 2, email: suscriptor.email, dominio_de_alta: dominio_de_alta) }

    context "con dos suscripciones del mismo suscriptor" do
      context "pasando un email y un dominio" do
        let(:suscriptor) { build(:suscriptor_anonimo) }
        it "encuentra las suscripciones" do
          expect(described_class.busca_suscripciones(suscriptor.email, dominio_de_alta).size).to eq(2)
        end
      end

      context "pasando un suscriptor y un dominio" do
        let(:suscriptor) { create(:usuario) }
        it "encuentra las suscripciones" do
          expect(described_class.busca_suscripciones(suscriptor.email, dominio_de_alta).size).to eq(2)
        end
      end
    end
  end

  describe ".desuscribir" do
    context "pasando un email" do
      context "con una suscripción" do
        let!(:suscripcion) { create(:suscripcion) }
        let(:suscribible) { suscripcion.suscribible }

        it "elimina la suscripción a partir del email, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: suscripcion.email, dominio_de_alta: dominio_de_alta)
            .where(suscribible_id: suscribible.id, suscribible_type: suscribible.class.name)
          expect(suscripciones_encontradas).to be_present

          expect(described_class.desuscribir(suscripcion.email, suscribible, suscripcion.dominio_de_alta)).to be_present

          suscripciones_encontradas.reload
          expect(suscripciones_encontradas).to be_empty
        end
      end

      context "con varias suscripciones" do
        let(:email) { FFaker::Internet.email }
        let!(:suscripciones) { create_list(:suscripcion, 3, email: email, dominio_de_alta: dominio_de_alta) }

        it "elimina las suscripciones a partir del email, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: email, dominio_de_alta: dominio_de_alta)
          expect(suscripciones_encontradas).to be_present

          expect(described_class.desuscribir(email, suscripciones.map(&:suscribible), dominio_de_alta)).to be_present

          suscripciones_encontradas.reload
          expect(suscripciones_encontradas).to be_empty
        end
      end
    end

    context "pasando un suscriptor" do
      context "con una suscripción" do
        let!(:suscripcion) { create(:suscripcion_con_suscriptor) }
        let(:suscribible) { suscripcion.suscribible }

        it "elimina la suscripción a partir del suscriptor, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: suscripcion.email, dominio_de_alta: dominio_de_alta)
            .where(suscribible_id: suscribible.id, suscribible_type: suscribible.class.name)
          expect(suscripciones_encontradas).to be_present

          expect(described_class.desuscribir(suscripcion.suscriptor, suscribible, dominio_de_alta)).to be_present

          suscripciones_encontradas.reload
          expect(suscripciones_encontradas).to be_empty
        end
      end

      context "con varias suscripciones" do
        let(:suscriptor) { create(:usuario) }
        let!(:suscripciones) { create_list(:suscripcion_con_suscriptor, 3, suscriptor: suscriptor) }

        it "elimina las suscripciones a partir del email, suscribible y dominio" do
          suscripciones_encontradas = described_class.where(email: suscriptor.email, dominio_de_alta: dominio_de_alta)
          expect(suscripciones_encontradas).to be_present

          suscribibles = suscripciones.map(&:suscribible)
          expect(described_class.desuscribir(suscriptor, suscribibles, dominio_de_alta)).to be_present

          suscripciones_encontradas.reload
          expect(suscripciones_encontradas).to be_empty
        end
      end
    end
  end

  describe "#nombre_lista" do
    subject { create(:suscripcion) }

    it "delega el método a su suscribible" do
      expect(subject.nombre_lista).to eq(subject.suscribible.nombre_lista)
    end
  end
end
