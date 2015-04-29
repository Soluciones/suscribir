# This migration comes from suscribir (originally 20150429090008)
class AddContactoIdToSuscripcion < ActiveRecord::Migration
  def change
    add_column :suscribir_suscripciones, :contacto_id, :integer
    add_index :suscribir_suscripciones, :contacto_id
  end
end
