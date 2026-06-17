class ClasificacionesController < ApplicationController

  def index

    @grupos = Grupo.includes(:selecciones)
                   .order(:nombre)

    @clasificaciones = {}

    terceros = []

    @grupos.each do |grupo|

      tabla = grupo.selecciones.order(
        puntos: :desc,
        diferencia_goles: :desc,
        goles_favor: :desc
      )

      @clasificaciones[grupo.id] = tabla

      terceros << tabla[2] if tabla.size >= 3

    end

    @mejores_terceros = terceros.sort_by do |equipo|
    [
        -equipo.puntos,
        -equipo.diferencia_goles,
        -equipo.goles_favor
    ]
    end.first(8)

    @ids_mejores_terceros = @mejores_terceros.map(&:id)

  end

end