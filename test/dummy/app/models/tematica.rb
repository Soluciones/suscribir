module Tematica
  class Tematica < ActiveRecord::Base
    include Suscribir::Suscribible
  end
end
