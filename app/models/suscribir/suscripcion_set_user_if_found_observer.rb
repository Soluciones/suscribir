module Suscribir
  class SuscripcionSetUserIfFoundObserver
    def update(metodo, suscripcion)
      return unless metodo.to_sym == Suscripcion::EVENTO_SUSCRIBIR

      return unless usuario_encontrado = Usuario.where(email: suscripcion.email).first
      suscripcion.update_attribute(:suscriptor, usuario_encontrado)
    end
  end
end
