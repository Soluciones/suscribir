class CreateSuscribirSuscripciones < ActiveRecord::Migration
  def change
    create_table :suscribir_suscripciones, force: true do |t|
      t.integer  :suscribible_id, null: false
      t.integer  :suscribible_type, null: false
      t.string   :dominio_de_alta, null: false, default: 'es'
      t.integer  :suscriptor_id
      t.string   :suscriptor_type
      t.string   :email, null: false
      t.string   :nombre_apellidos
      t.string   :cod_postal
      t.integer  :provincia_id
      t.boolean  :activo, default: true
      t.timestamps
    end

    add_index :suscribir_suscripciones, [:suscribible_type, :suscribible_id, :dominio_de_alta, :email], unique: true, name: 'ix_suscripciones_on_suscribible_and_dominio_and_email'
    add_index :suscribir_suscripciones, [:activo, :suscribible_type, :suscribible_id, :dominio_de_alta], name: 'ix_suscripciones_on_activo_and_suscribible_and_dominio'
    add_index :suscribir_suscripciones, [:suscriptor_type, :suscriptor_id, :activo], name: 'ix_suscripciones_on_suscriptor_and_activo'
    add_index :suscribir_suscripciones, :email
    add_index :suscribir_suscripciones, [:provincia_id, :activo, :suscribible_type, :suscribible_id, :dominio_de_alta], name: 'ix_suscripciones_on_provincia_activo_suscribible_and_dominio'
  end
end
