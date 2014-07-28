class CreateSuscribirNewsletters < ActiveRecord::Migration
  def change
    create_table :suscribir_newsletters do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
