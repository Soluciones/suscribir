module Suscribir
  class Newsletter < ActiveRecord::Base
    include Suscribible
  end
end
