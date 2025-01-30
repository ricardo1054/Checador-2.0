class AddCountersToTurnos < ActiveRecord::Migration[7.1]
  def change
    add_column :turnos, :retardos_count, :integer, default: 0
    add_column :turnos, :faltas_count, :integer, default: 0
  end
end