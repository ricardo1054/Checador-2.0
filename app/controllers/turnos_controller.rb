class TurnosController < ApplicationController
  before_action :set_turno, only: [:show, :edit, :update, :destroy]

  def index
    @turnos = Turno.order(fecha: :desc, hora_entrada: :desc)
  end

  def show
  end

  def new
    @turno = Turno.new
  end

  def edit
  end

  def create
    @turno = Turno.new(turno_params)
    if @turno.save
      redirect_to @turno, notice: 'Turno creado exitosamente.'
    else
      render :new
    end
  end

  def update
    if @turno.update(turno_params)
      redirect_to @turno, notice: 'Turno actualizado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @turno.destroy
    redirect_to turnos_url, notice: 'Turno eliminado exitosamente.'
  end

  def registrar_entrada
    if params[:empleado].blank?
      redirect_to turnos_path, alert: 'Por favor ingrese el nombre del empleado.'
      return
    end

    # Verificar si ya existe un turno sin salida para este empleado
    if Turno.sin_salida_para(params[:empleado])
      redirect_to turnos_path, alert: 'Ya tienes un turno activo. Registra la salida primero.'
      return
    end

    now = Time.current
    
    @turno = Turno.new(
      empleado: params[:empleado],
      fecha: now.to_date,
      hora_entrada: now,
      turno_tipo: params[:turno_tipo],
      estado: 'pendiente',
      retardos_count: 0,
      faltas_count: 0
    )

    if @turno.save
      @turno.evaluar_entrada
      redirect_to turnos_path, notice: generar_mensaje_entrada(@turno)
    else
      redirect_to turnos_path, alert: 'Error al registrar entrada.'
    end
  end

  def registrar_salida
    return redirect_to turnos_path, alert: 'Por favor ingrese el nombre del empleado.' if params[:empleado].blank?

    @turno = Turno.sin_salida_para(params[:empleado])
    
    if @turno.nil?
      redirect_to turnos_path, alert: 'No se encontró una entrada sin salida registrada.'
    else
      Turno.transaction do
        @turno.update!(hora_salida: Time.zone.now)
      end
      redirect_to turnos_path, notice: 'Salida registrada exitosamente.'
    end
  rescue => e
    Rails.logger.error "Error registrando salida: #{e.message}"
    redirect_to turnos_path, alert: 'Error al registrar la salida.'
  end

  def detalles
    @empleado = params[:empleado]
    @turnos = Turno.where(empleado: @empleado)
                   .order(fecha: :desc, hora_entrada: :desc)
    
    @retardos = @turnos.sum(:retardos_count)
    @faltas = @turnos.sum(:faltas_count)
  end

  private

  def set_turno
    @turno = Turno.find(params[:id])
  end

  def turno_params
    params.permit(:empleado, :fecha, :hora_entrada, :turno_tipo)
  end

  def generar_mensaje_entrada(turno)
    case turno.estado
    when 'en_curso'
      'Entrada registrada exitosamente.'
    when 'retardo'
      "Retardo registrado. Llevas #{turno.retardos_count} retardo(s)."
    when 'falta'
      "Falta registrada. Llevas #{turno.faltas_count} falta(s)."
    else
      'Entrada registrada.'
    end
  end
end