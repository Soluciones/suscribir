require 'rails_helper'

describe 'desuscribir' do
  context 'con una suscripción ya existente' do
    let(:suscribible) { create(:contenido) }
    let(:suscripcion) { create(:suscripcion, suscribible: suscribible, suscriptor: build_stubbed(:usuario)) }

    it 'muestra el enlace de desuscribir' do
      visit "/suscribir/confirmar_baja/#{ suscripcion.id }/#{ suscripcion.token }"
      expect(page.status_code).to be(200)
    end
  end
end
