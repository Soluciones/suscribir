class CreateContenido < ActiveRecord::Migration
  def change
    create_table :contenidos do |t|
      t.string :titulo
    end
  end
end
