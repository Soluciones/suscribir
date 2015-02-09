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

    context 'con una tematica, su equivalente en Base64 y un email tambien en Base64' do
      let(:suscripcion) { create(:suscripcion_con_suscriptor) }
      let(:tematica) { create(:tematica) }
      let(:clase) { tematica.class }
      let(:tematica_64) { Base64.encode64(tematica.class.to_s) }
      let(:email) { suscripcion.email }
      let(:email_64) { Base64.encode64(email) }

      describe 'baja_realizada' do
        it 'debe mostrar la pagina si el token es correcto' do
          token_bueno = Suscripcion.new(email: email, suscribible_id: tematica.id, suscribible_type: clase).token
          get :baja_realizada, type: tematica_64, suscribible_id: tematica.id, email: email_64, token: token_bueno
          expect(response).to be_ok
        end

        it 'debe mostrar nuestro 404 si el token es incorrecto' do
          get :baja_realizada, type: tematica_64, suscribible_id: tematica.id, email: email_64, token: 'incorrect_token'
          expect(response.status).to eq(404)
        end
      end

      describe 'resuscribir' do
        it 'esperamos un 404 si el token no es correcto' do
          get :resuscribir, type: tematica_64, suscribible_id: tematica.id, email: email_64, token: 'incorrect_token'
          expect(response.status).to eq(404)
        end

        it 'esperamos que se cree una suscripcion con el email de un usuario registrado' do
          usuario = create(:usuario, email: email)

          token_bueno = Digest::SHA1.hexdigest(
            "#{ usuario.email }#{ tematica.class }#{ tematica.id }#{ Rails.application.secrets.esta_web_secret_token }")

          expect do
            get :resuscribir, type: tematica_64, suscribible_id: tematica.id, email: email_64, token: token_bueno
          end.to change(Suscripcion, :count).by(1)
        end

        it 'esperamos que se cree una suscripcion con el email de un usuario anonimo' do
          token_bueno = Digest::SHA1.hexdigest(
            "#{ email }#{ tematica.class }#{ tematica.id }#{ Rails.application.secrets.esta_web_secret_token }")

          expect do
            get :resuscribir, type: tematica_64, suscribible_id: tematica.id, email: email_64, token: token_bueno
          end.to change(Suscripcion, :count).by(1)
        end
      end
    end
  end
end
