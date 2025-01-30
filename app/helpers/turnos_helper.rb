module TurnosHelper
  def turno_row_class(turno)
    case turno.estado
    when 'retardo'
      'table-warning'
    when 'falta'
      'table-danger'
    when 'en_curso'
      'table-success'
    else
      ''
    end
  end

  def turno_tipo_badge(tipo)
    case tipo
    when 'matutino'
      content_tag(:span, 'Matutino', class: 'badge bg-primary')
    when 'vespertino'
      content_tag(:span, 'Vespertino', class: 'badge bg-info')
    when 'nocturno'
      content_tag(:span, 'Nocturno', class: 'badge bg-dark')
    else
      content_tag(:span, 'No definido', class: 'badge bg-secondary')
    end
  end

  def estado_class(estado)
    case estado
    when 'pendiente'
      'bg-info'
    when 'en_curso'
      'bg-primary'
    when 'retardo'
      'bg-warning'
    when 'falta'
      'bg-danger'
    when 'completado'
      'bg-success'
    else
      'bg-secondary'
    end
  end
end