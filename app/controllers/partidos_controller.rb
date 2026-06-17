class PartidosController < ApplicationController
  before_action :set_partido, only: [:show, :edit, :update, :destroy]

  def index
    @grupos = Grupo.order(:nombre)

    if params[:grupo_id].present?
      @grupo = Grupo.find(params[:grupo_id])
      @partidos = @grupo.partidos.includes(:seleccion_a, :seleccion_b)
    else
      @partidos = []
    end
  end

  def show
  end

  def new
    @partido = Partido.new
  end

  def create
    @partido = Partido.new(partido_params)

    if @partido.save
      redirect_to partidos_path,
                  notice: "Partido creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    datos = partido_params

    datos[:jugado] = true

    if @partido.update(datos)

      @partido.seleccion_a.recalcular_estadisticas
      @partido.seleccion_b.recalcular_estadisticas

      redirect_to partidos_path(
        grupo_id: @partido.grupo_id
      ),
      notice: "Resultado registrado correctamente."

    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @partido.destroy

    redirect_to partidos_path,
                notice: "Partido eliminado correctamente."
  end

  def generar
    grupo = Grupo.find(params[:grupo_id])

    grupo.generar_partidos

    redirect_to partidos_path(
              grupo_id: grupo.id
            ),
            notice: "Partidos generados correctamente para el Grupo #{grupo.nombre}."
   end

  private

  def set_partido
    @partido = Partido.find(params[:id])
  end

  def partido_params
    params.require(:partido).permit(
      :goles_a,
      :goles_b
    )
  end
end