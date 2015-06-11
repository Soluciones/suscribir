class AddSuscripcionesCountToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :suscripciones_count, :integer, default: 0
    add_index :usuarios, :suscripciones_count
  end
end
