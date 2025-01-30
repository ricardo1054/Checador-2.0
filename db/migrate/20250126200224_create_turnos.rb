class CreateTurnos < ActiveRecord::Migration[7.0]
  def change
    create_table :turnos do |t|
      t.string :empleado
      t.date :fecha
      t.datetime :hora_entrada
      t.datetime :hora_salida
      t.string :turno_tipo
      t.string :estado
      t.integer :retardos_count, default: 0
      t.integer :faltas_count, default: 0

      t.timestamps
    end
    add_index :turnos, :empleado
  end
end