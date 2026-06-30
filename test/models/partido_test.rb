require "test_helper"

class PartidoTest < ActiveSupport::TestCase
  test "reiniciar_eliminatoria deletes every knockout match" do
    grupo = grupos(:one)
    seleccion_a = seleccions(:one)
    seleccion_b = seleccions(:two)

    partido = Partido.create!(
      fase: "eliminatoria",
      ronda: "octavos",
      orden: 1,
      seleccion_a: seleccion_a,
      seleccion_b: seleccion_b
    )

    assert_difference("Partido.eliminatoria.count", -1) do
      Partido.reiniciar_eliminatoria!
    end

    assert_not Partido.exists?(partido.id)
  end
end