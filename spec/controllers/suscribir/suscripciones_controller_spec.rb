require 'rails_helper'

module Suscribir
  describe SuscripcionesController do
    routes { Suscribir::Engine.routes }

    describe 'desuscribir' do
      let(:suscripcion) { create(:suscripcion) }

      it 'debe borrar la suscripcion si el token es correcto' do
        params_baja_por_email = { suscripcion_id: suscripcion.id, token: suscripcion.token }
        delete :desuscribir, params_baja_por_email
        expect(Suscribir::Suscripcion.where(id: suscripcion.id)).to be_empty
      end

      it 'no debe borrar la suscripcion si el token es incorrecto' do
        params_baja_por_email = { suscripcion_id: suscripcion.id, token: 'incorrect_token' }
        delete :desuscribir, params_baja_por_email
        expect(Suscribir::Suscripcion.where(id: suscripcion.id)).not_to be_empty
      end
    end

    describe 'baja_realizada' do
      let(:tematica) { create(:tematica) }
      let(:tematica_64) { Base64.encode64(tematica.class.to_s) }
      let(:email) { Base64.encode64(Faker::Internet.email) }

      it 'debe mostrar la pagina si el token es correcto' do
        email_tokenizada = tokeniza_email(email)
        get :baja_realizada, type: tematica_64, suscribible_id: tematica.id, email: email, token: email_tokenizada
        expect(response).to be_ok
      end

      it 'debe mostrar nuestro 404 si el token es incorrecto' do
        get :baja_realizada, type: tematica_64, suscribible_id: tematica.id, email: email, token: 'incorrect_token'
        expect(response.status).to eq(404)
      end
    end
  end
end
