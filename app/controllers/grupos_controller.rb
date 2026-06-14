class GruposController < ApplicationController
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]

  # Lista todos los grupos
  def index
    @grupos = Grupo.all.order(:nombre)
  end

  # Muestra un grupo con sus selecciones
  def show
    @selecciones = @grupo.selecciones.order(puntos: :desc)
  end

  # Formulario para nuevo grupo
  def new
    @grupo = Grupo.new
  end

  # Crea un grupo nuevo
  def create
    @grupo = Grupo.new(grupo_params)
    if @grupo.save
      redirect_to @grupo, notice: "Grupo creado exitosamente."
    else
      render :new
    end
  end

  # Formulario para editar
  def edit
  end

  # Actualiza un grupo
  def update
    if @grupo.update(grupo_params)
      redirect_to @grupo, notice: "Grupo actualizado."
    else
      render :edit
    end
  end

  # Elimina un grupo
  def destroy
    @grupo.destroy
    redirect_to grupos_path, notice: "Grupo eliminado."
  end

  private

  def set_grupo
    @grupo = Grupo.find(params[:id])
  end

  def grupo_params
    params.require(:grupo).permit(:nombre)
  end
end