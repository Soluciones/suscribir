# This migration comes from suscribir (originally 20140224125451)
class ChangeSuscribibleTypeToSuscripcion < ActiveRecord::Migration
  def up
    change_table :suscribir_suscripciones do |t|
      t.change :suscribible_type, :string
    end
  end

  def down
    change_table :suscribir_suscripciones do |t|
      t.change :suscribible_type, :integer
    end
  end
end
