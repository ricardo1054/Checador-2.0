class Turno < ApplicationRecord
  before_save :normalize_hora_entrada
  
  def self.sin_salida_para(empleado)
    where(empleado: empleado, fecha: Date.current, hora_salida: nil).first
  end

  def normalize_hora_entrada
    return unless hora_entrada_changed?
    self.hora_entrada = hora_entrada.change(year: fecha.year, month: fecha.month, day: fecha.day)
  end

  def evaluar_entrada
    self.estado = calcular_estado
    actualizar_contadores
    save
  end

  private

  def calcular_estado
    hora_esperada = case turno_tipo
    when 'matutino'
      hora_entrada.change(hour: 9, min: 0)
    when 'vespertino'
      hora_entrada.change(hour: 15, min: 0)
    when 'nocturno'
      hora_entrada.change(hour: 23, min: 0)
    end

    diferencia_minutos = ((hora_entrada - hora_esperada) / 60).to_i

    if diferencia_minutos <= 0
      'en_curso'
    elsif diferencia_minutos <= 15
      'retardo'
    else
      'falta'
    end
  end

  def actualizar_contadores
    self.retardos_count ||= 0
    self.faltas_count ||= 0

    case estado
    when 'retardo'
      self.retardos_count += 1
    when 'falta'
      self.faltas_count += 1
    end
  end
end