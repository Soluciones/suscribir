module Suscribir
  module SuscribibleDecorator
    def param_key
      source.class.model_name.param_key
    end
  end
end
