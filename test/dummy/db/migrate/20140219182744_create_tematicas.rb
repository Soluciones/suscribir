class CreateTematicas < ActiveRecord::Migration
  def change
    create_table :tematicas do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
