class AddProcedenciaFrecuenciaAndMejoresToSuscripciones < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE procedencia AS ENUM ('todos', 'blogs', 'foros', 'vídeos');
      CREATE TYPE frecuencia AS ENUM ('inmediata', 'diaria', 'semanal');
    SQL
    add_column :suscribir_suscripciones, :procedencia, :procedencia, default: 'todos'
    add_column :suscribir_suscripciones, :frecuencia, :frecuencia, default: 'inmediata'
    add_column :suscribir_suscripciones, :mejores, :boolean, default: false
  end

  def down
    remove_column :suscribir_suscripciones, :procedencia
    remove_column :suscribir_suscripciones, :frecuencia
    remove_column :suscribir_suscripciones, :mejores
    execute <<-SQL
      DROP TYPE procedencia;
      DROP TYPE frecuencia;
    SQL
  end
end
