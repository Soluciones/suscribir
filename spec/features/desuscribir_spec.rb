require 'rails_helper'

describe 'desuscribir' do
  context 'con una suscripción ya existente' do
    let(:suscribible) { create(:contenido) }
    let(:suscripcion) { create(:suscripcion, suscribible: suscribible, suscriptor: build_stubbed(:usuario)) }

    it 'muestra el enlace de desuscribir' do
      visit "/suscribir/confirmar_baja/#{ suscripcion.id }/#{ suscripcion.token }"
      expect(page.status_code).to be(200)
      expect(page).to have_button('Sí, quiero cancelar mi suscripción')
      click_button 'Sí, quiero cancelar mi suscripción'
      suscribible.reload
      expect(suscribible.suscripciones.count).to eq(0)
    end
  end
end
