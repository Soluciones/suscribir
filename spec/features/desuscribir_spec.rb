require 'rails_helper'
require 'temping'

Temping.create :mi_suscribible do
  include Suscribir::Suscribible
  with_columns do |t|
    t.string(:titulo)
    t.integer(:suscripciones_count)
  end
end

describe 'desuscribir' do
  context 'con una suscripción ya existente' do
    let(:suscribible) { MiSuscribible.create!(titulo: 'Foo') }
    let(:suscripcion) { create(:suscripcion_con_suscriptor, suscribible: suscribible) }
    let(:tipo) { Base64.encode64('MiSuscribible') }
    let(:email) { Base64.encode64(suscripcion.email) }
    let!(:token) { suscripcion.token }
    let(:url) { "http://www.example.com/suscribir/resuscribir/#{ tipo }/#{ suscribible.id }/#{ email }/#{ token }" }

    it 'muestra el enlace de desuscribir, desuscribe y resuscribe' do
      visit "/suscribir/confirmar_baja/#{ suscripcion.id }/#{ suscripcion.token }"
      expect(page.status_code).to be(200)
      expect(page).to have_button('Sí, quiero cancelar mi suscripción')

      click_button 'Sí, quiero cancelar mi suscripción'
      mail_enviado = ActionMailer::Base.deliveries.last
      expect(mail_enviado).to be_present
      expect(mail_enviado).to deliver_from(Suscribir::Personalizacion.email_contacto)
      expect(mail_enviado).to deliver_to(suscripcion.email)
      expect(mail_enviado).to have_body_text(/|#{url}|/)
      suscribible.reload
      expect(suscribible.suscripciones.count).to eq(0)
      expect(page).to have_link('activar de nuevo tu suscripción', href: url.gsub("\n", "%0A"))

      click_link 'activar de nuevo tu suscripción'
      mail_enviado = ActionMailer::Base.deliveries.last
      expect(mail_enviado).to be_present
      expect(mail_enviado).to deliver_from(Suscribir::Personalizacion.email_contacto)
      expect(mail_enviado).to deliver_to(suscripcion.email)
      expect(mail_enviado).to have_subject('Suscripción confirmada')
      suscribible.reload
      expect(suscribible.suscripciones.count).to eq(1)
      expect(page).to have_css('h1', 'Bienvenido de nuevo')

      contador_enviados = ActionMailer::Base.deliveries.count
      visit url.gsub("\n", "%0A")
      expect(ActionMailer::Base.deliveries.count).to eq contador_enviados
      suscribible.reload
      expect(suscribible.suscripciones.count).to eq(1)
      expect(page).to have_css('h1', 'Bienvenido de nuevo')
    end
  end
end
