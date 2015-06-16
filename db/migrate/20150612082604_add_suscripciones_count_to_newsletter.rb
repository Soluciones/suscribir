class AddSuscripcionesCountToNewsletter < ActiveRecord::Migration
  def up
    add_column :suscribir_newsletters, :suscripciones_count, :integer, default: 0
    add_index :suscribir_newsletters, :suscripciones_count

    execute <<-SQL
    UPDATE suscribir_newsletters set suscripciones_count = (
      SELECT count(*)
      FROM suscribir_suscripciones
      WHERE suscribible_type = 'Suscribir::Newsletter' AND suscribible_id = suscribir_newsletters.id
    );
    SQL
  end

  def down
    remove_index :suscribir_newsletters, :suscripciones_count
    remove_column :suscribir_newsletters, :suscripciones_count
  end
end
