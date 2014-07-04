module Suscribir
  class NewsletterDecorator < Draper::Decorator
    delegate_all

    include Decorators::Suscribible
  end
end
