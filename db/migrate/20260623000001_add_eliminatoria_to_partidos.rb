class AddEliminatoriaToPartidos < ActiveRecord::Migration[7.1]
  def change
    change_column_null :partidos, :grupo_id, true

    add_column :partidos, :fase, :string, null: false, default: "grupos"
    add_column :partidos, :ronda, :string
    add_column :partidos, :orden, :integer
    add_column :partidos, :penales_a, :integer, default: 0
    add_column :partidos, :penales_b, :integer, default: 0

    add_index :partidos, [:fase, :ronda, :orden]
  end
end