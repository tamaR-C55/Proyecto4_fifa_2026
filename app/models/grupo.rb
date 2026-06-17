class Grupo < ApplicationRecord
  # Le decimos explícitamente el nombre de la clase
  has_many :selecciones, class_name: "Seleccion", dependent: :destroy
  has_many :partidos, dependent: :destroy

  validates :nombre, presence: true, uniqueness: true,
            inclusion: { in: %w[A B C D E F G H I J K L] }

  def generar_partidos
  return if selecciones.count != 4
  return if partidos.exists?

  equipos = selecciones.to_a

  equipos.combination(2).each do |equipo_a, equipo_b|
    partidos.create!(
      seleccion_a_id: equipo_a.id,
      seleccion_b_id: equipo_b.id
    )
  end
end
end