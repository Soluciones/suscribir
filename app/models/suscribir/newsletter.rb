module Suscribir
  class Newsletter < ActiveRecord::Base
    attr_accessible :nombre
    include Suscribible
  end
end
