class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :apellidos
      t.string :email
      t.string :cod_postal
      t.integer :provincia_id
      t.timestamps
    end
  end
end
