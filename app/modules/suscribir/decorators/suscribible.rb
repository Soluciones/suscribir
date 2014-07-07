module Suscribir::Decorators::Suscribible
  def param_key
    source.class.model_name.param_key
  end
end
