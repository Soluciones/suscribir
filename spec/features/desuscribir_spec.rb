require 'rails_helper'

describe 'desuscribir' do
  context 'con una suscripción ya existente' do
    let(:suscribible) { create(:contenido) }
    let(:suscripcion) { create(:suscripcion_con_suscriptor, suscribible: suscribible) }
    let(:tipo) { Base64.encode64('Contenido') }
    let(:email) { Base64.encode64(suscripcion.email) }
    let!(:token) { suscripcion.token }
    let(:url) { "http://www.example.com/suscribir/resuscribir/#{ tipo }/#{ suscribible.id }/#{ email }/#{ token }" }


    it 'muestra el enlace de desuscribir' do
      visit "/suscribir/confirmar_baja/#{ suscripcion.id }/#{ suscripcion.token }"
      expect(page.status_code).to be(200)
      expect(page).to have_button('Sí, quiero cancelar mi suscripción')
      click_button 'Sí, quiero cancelar mi suscripción'
      suscribible.reload
      expect(suscribible.suscripciones.count).to eq(0)
      expect(page).to have_link('activar de nuevo tu suscripción', href: url.gsub("\n", "%0A"))
      click_link 'activar de nuevo tu suscripción'
      suscribible.reload
      expect(suscribible.suscripciones.count).to eq(1)
    end
  end
end
