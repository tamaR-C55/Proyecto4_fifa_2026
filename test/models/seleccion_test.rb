require "test_helper"

class SeleccionTest < ActiveSupport::TestCase
  test "destroying a selection removes its associated partidos" do
    grupo = grupos(:one)
    seleccion = seleccions(:one)

    rival_a = Seleccion.create!(
      pais: "Rival A",
      grupo: grupo,
      puntos: 0,
      goles_favor: 0,
      goles_contra: 0,
      diferencia_goles: 0
    )

    rival_b = Seleccion.create!(
      pais: "Rival B",
      grupo: grupo,
      puntos: 0,
      goles_favor: 0,
      goles_contra: 0,
      diferencia_goles: 0
    )

    partido_como_a = Partido.create!(
      fase: "eliminatoria",
      ronda: "octavos",
      orden: 1,
      seleccion_a: seleccion,
      seleccion_b: rival_a
    )

    partido_como_b = Partido.create!(
      fase: "eliminatoria",
      ronda: "octavos",
      orden: 2,
      seleccion_a: rival_b,
      seleccion_b: seleccion
    )

    assert_difference("Partido.count", -2) do
      seleccion.destroy
    end

    assert_not Partido.exists?(partido_como_a.id)
    assert_not Partido.exists?(partido_como_b.id)
  end
end
