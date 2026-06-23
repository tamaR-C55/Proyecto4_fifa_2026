class ClasificacionesController < ApplicationController

  def index

    @grupos, @clasificaciones, @mejores_terceros = Seleccion.clasificacion_mundial

    @ids_mejores_terceros = @mejores_terceros.map(&:id)

  end

end