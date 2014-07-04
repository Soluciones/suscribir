require 'spec_helper'

describe Suscribir::NewsletterDecorator do
  describe 'param_key' do
    it 'devuelve "newsletter"' do
      expect(Suscribir::Newsletter.new.decorate.param_key).to eq('newsletter')
    end
  end
end
