class Partido < ApplicationRecord
  belongs_to :grupo

  belongs_to :seleccion_a,
             class_name: "Seleccion",
             foreign_key: "seleccion_a_id"

  belongs_to :seleccion_b,
             class_name: "Seleccion",
             foreign_key: "seleccion_b_id"

  validates :seleccion_a_id, presence: true
  validates :seleccion_b_id, presence: true

  validate :selecciones_diferentes

  private

  def selecciones_diferentes
    if seleccion_a_id == seleccion_b_id
      errors.add(:seleccion_b_id, "debe ser diferente de la selección A")
    end
  end
end