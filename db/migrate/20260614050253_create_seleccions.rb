class CreateSeleccions < ActiveRecord::Migration[7.1]
  def change
    create_table :seleccions do |t|
      t.string :pais
      t.integer :puntos
      t.integer :goles_favor
      t.integer :goles_contra
      t.integer :diferencia_goles
      t.references :grupo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
