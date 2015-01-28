require 'rails_helper'

describe Suscribir::Newsletter do
  describe 'integración con NewsletterDecorator y Decorators::Suscribible' do
    it 'tras decorar Newsletter, una llamada básica responde correctamente' do
      expect(Suscribir::Newsletter.new.decorate.param_key).to eq('newsletter')
    end
  end
end
