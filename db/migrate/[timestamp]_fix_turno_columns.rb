class FixTurnoColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :turnos, :hora_entrada, :datetime
    change_column :turnos, :retardos_count, :integer, default: 0
    change_column :turnos, :faltas_count, :integer, default: 0
    
    execute "UPDATE turnos SET retardos_count = 0 WHERE retardos_count IS NULL"
    execute "UPDATE turnos SET faltas_count = 0 WHERE faltas_count IS NULL"
  end
end