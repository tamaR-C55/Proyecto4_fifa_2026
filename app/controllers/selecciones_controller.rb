class SeleccionesController < ApplicationController
  before_action :set_seleccion, only: [:show, :edit, :update, :destroy]

  def index
    @selecciones = Seleccion.all.includes(:grupo).order(:pais)
  end

  def show
  end

  def new
    @seleccion = Seleccion.new
    @seleccion.grupo_id = params[:grupo_id] if params[:grupo_id]
    @grupos = Grupo.all.order(:nombre)
  end

  def create
    @seleccion = Seleccion.new(seleccion_params)
    if @seleccion.save
      # Redirigir al grupo si viene de ahí
      if @seleccion.grupo
        redirect_to grupo_path(@seleccion.grupo), notice: "#{@seleccion.bandera} #{@seleccion.pais} registrada en el Grupo #{@seleccion.grupo.nombre}."
      else
        redirect_to @seleccion, notice: "Selección registrada exitosamente."
      end
    else
      @grupos = Grupo.all.order(:nombre)
      render :new
    end
  end

  def edit
    @grupos = Grupo.all.order(:nombre)
  end

  def update
    if @seleccion.update(seleccion_params)
      # Redirigir al grupo si tiene uno asignado
      if @seleccion.grupo
        redirect_to grupo_path(@seleccion.grupo), notice: "#{@seleccion.bandera} #{@seleccion.pais} actualizada."
      else
        redirect_to @seleccion, notice: "Selección actualizada."
      end
    else
      @grupos = Grupo.all.order(:nombre)
      render :edit
    end
  end

  def destroy
    grupo = @seleccion.grupo
    nombre = @seleccion.pais
    bandera = @seleccion.bandera
    @seleccion.destroy

    # Redirigir al grupo si tenía uno, si no a la lista general
    if grupo
      redirect_to grupo_path(grupo), notice: "#{bandera} #{nombre} eliminada del Grupo #{grupo.nombre}."
    else
      redirect_to selecciones_path, notice: "#{bandera} #{nombre} eliminada."
    end
  end

  private

  def set_seleccion
    @seleccion = Seleccion.find(params[:id])
  end

  def seleccion_params
    params.require(:seleccion).permit(:pais, :grupo_id, :puntos,
                                      :goles_favor, :goles_contra,
                                      :diferencia_goles)
  end
end
