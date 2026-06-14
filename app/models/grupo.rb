class Grupo < ApplicationRecord
  # Le decimos explícitamente el nombre de la clase
  has_many :selecciones, class_name: "Seleccion", dependent: :destroy

  validates :nombre, presence: true, uniqueness: true,
            inclusion: { in: %w[A B C D E F G H I J K L] }
end