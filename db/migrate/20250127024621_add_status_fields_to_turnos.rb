class AddFieldsToTurnos < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:turnos, :turno_tipo)
      add_column :turnos, :turno_tipo, :string
    end

    unless column_exists?(:turnos, :estado)
      add_column :turnos, :estado, :string, default: 'exitoso'
    end

    unless column_exists?(:turnos, :retardos_count)
      add_column :turnos, :retardos_count, :integer, default: 0, null: false
    end

    unless column_exists?(:turnos, :faltas_count)
      add_column :turnos, :faltas_count, :integer, default: 0, null: false
    end

    add_index :turnos, :empleado
    add_index :turnos, :estado
    add_index :turnos, [:empleado, :fecha]
  end

  def index
    @turnos = Turno.all.order(created_at: :desc)
    Rails.logger.debug "DEBUG: Found #{@turnos.count} turnos"
    Rails.logger.debug "DEBUG: SQL: #{@turnos.to_sql}"
  end
end

<div class="container">
  <h2>Historial de Asistencias</h2>
  
  <div class="table-responsive">
    <table class="table">
      <thead>
        <tr>
          <th>Empleado</th>
          <th>Fecha</th>
          <th>Entrada</th>
          <th>Salida</th>
          <th>Turno</th>
          <th>Estado</th>
          <th>Retardos</th>
          <th>Faltas</th>
        </tr>
      </thead>
      <tbody>
        <% if @turnos.any? %>
          <% @turnos.each do |turno| %>
            <tr>
              <td><%= turno.empleado %></td>
              <td><%= turno.fecha&.strftime("%d/%m/%Y") %></td>
              <td><%= turno.hora_entrada&.strftime("%H:%M") %></td>
              <td><%= turno.hora_salida&.strftime("%H:%M") if turno.hora_salida.present? %></td>
              <td><%= turno.turno_tipo %></td>
              <td><%= turno.estado %></td>
              <td><%= turno.retardos_count %></td>
              <td><%= turno.faltas_count %></td>
            </tr>
          <% end %>
        <% else %>
          <tr>
            <td colspan="8" class="text-center">
              <div class="alert alert-info m-0">
                No hay registros para este empleado.
              </div>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>
  </div>
</div>
