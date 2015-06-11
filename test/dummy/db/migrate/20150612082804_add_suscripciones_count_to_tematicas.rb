class AddSuscripcionesCountToTematicas < ActiveRecord::Migration
  def up
    add_column :tematicas, :suscripciones_count, :integer, default: 0
    add_index :tematicas, :suscripciones_count
  end

  def down
    remove_index :tematicas, :suscripciones_count
    remove_column :tematicas, :suscripciones_count
  end
end
