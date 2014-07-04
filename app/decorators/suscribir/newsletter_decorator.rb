module Suscribir
  class NewsletterDecorator < Draper::Decorator
    delegate_all

    include SuscribibleDecorator
  end
end
