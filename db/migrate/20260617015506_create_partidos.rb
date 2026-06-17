class CreatePartidos < ActiveRecord::Migration[7.1]
  def change
    create_table :partidos do |t|
      t.references :grupo, null: false, foreign_key: true

      t.integer :seleccion_a_id, null: false
      t.integer :seleccion_b_id, null: false

      t.integer :goles_a, default: 0
      t.integer :goles_b, default: 0

      t.boolean :jugado, default: false

      t.timestamps
    end
  end
end