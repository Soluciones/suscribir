class AddContactoIdToSuscripcion < ActiveRecord::Migration
  def change
    add_column :suscribir_suscripciones, :contacto_id, :integer
    add_index :suscribir_suscripciones, :contacto_id
  end
end
