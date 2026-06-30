class Seleccion < ApplicationRecord
  # Nombre exacto de la tabla en la base de datos
  self.table_name = "seleccions"

  belongs_to :grupo
  has_many :partidos_como_a,
         class_name: "Partido",
      foreign_key: "seleccion_a_id",
      dependent: :destroy

  has_many :partidos_como_b,
         class_name: "Partido",
      foreign_key: "seleccion_b_id",
      dependent: :destroy

  validates :pais, presence: true, uniqueness: true
  validates :puntos, :goles_favor, :goles_contra,
          numericality: { greater_than_or_equal_to: 0 }

  validates :diferencia_goles,
          numericality: true

  validate :limite_de_equipos_por_grupo

  scope :ordenadas_por_clasificacion, -> do
    order(
      puntos: :desc,
      diferencia_goles: :desc,
      goles_favor: :desc
    )
  end
  # Códigos ISO de país para mostrar como badge
  CODIGOS = {
    "Argentina" => "ARG", "Brasil" => "BRA", "México" => "MEX",
    "Costa Rica" => "CRC", "Francia" => "FRA", "España" => "ESP",
    "Alemania" => "GER", "Portugal" => "POR", "Inglaterra" => "ENG",
    "Italia" => "ITA", "Países Bajos" => "NED", "Bélgica" => "BEL",
    "Croacia" => "CRO", "Marruecos" => "MAR", "Senegal" => "SEN",
    "Japón" => "JPN", "Corea del Sur" => "KOR", "Australia" => "AUS",
    "USA" => "USA", "Canadá" => "CAN", "Uruguay" => "URU",
    "Colombia" => "COL", "Ecuador" => "ECU", "Chile" => "CHI",
    "Perú" => "PER", "Venezuela" => "VEN", "Paraguay" => "PAR",
    "Polonia" => "POL", "Suiza" => "SUI", "Dinamarca" => "DEN",
    "Suecia" => "SWE", "Noruega" => "NOR", "Austria" => "AUT",
    "Turquía" => "TUR", "Serbia" => "SRB", "Ucrania" => "UKR",
    "Arabia Saudita" => "KSA", "Irán" => "IRN", "Egipto" => "EGY",
    "Nigeria" => "NGA", "Ghana" => "GHA", "Camerún" => "CMR",
    "Costa de Marfil" => "CIV", "Mali" => "MLI", "Túnez" => "TUN",
    "Argelia" => "ALG", "Sudáfrica" => "RSA", "Nueva Zelanda" => "NZL",
    "Escocia" => "SCO", "Gales" => "WAL", "Irlanda" => "IRL",
    "Hungría" => "HUN", "República Checa" => "CZE", "Eslovenia" => "SVN",
    "Albania" => "ALB", "Georgia" => "GEO", "Eslovaquia" => "SVK",
    "Rumania" => "ROU", "Irak" => "IRQ"
  }

  # Retorna el código ISO del país (3 letras)
  def codigo
    CODIGOS[pais] || pais&.upcase&.first(3) || "???"
  end

  def recalcular_estadisticas
  puntos_calculados = 0
  goles_favor_calculados = 0
  goles_contra_calculados = 0

  partidos_jugados = Partido.where(jugado: true, fase: "grupos")
                            .where(
                              "seleccion_a_id = ? OR seleccion_b_id = ?",
                              id, id
                            )

  partidos_jugados.each do |partido|

    if partido.seleccion_a_id == id
      goles_mios = partido.goles_a
      goles_rival = partido.goles_b
    else
      goles_mios = partido.goles_b
      goles_rival = partido.goles_a
    end

    goles_favor_calculados += goles_mios
    goles_contra_calculados += goles_rival

    if goles_mios > goles_rival
      puntos_calculados += 3
    elsif goles_mios == goles_rival
      puntos_calculados += 1
    end
  end

  update!(
    puntos: puntos_calculados,
    goles_favor: goles_favor_calculados,
    goles_contra: goles_contra_calculados,
    diferencia_goles: goles_favor_calculados - goles_contra_calculados
  )
  end

  def self.clasificacion_mundial
    grupos = Grupo.includes(:selecciones).order(:nombre)
    clasificaciones = {}
    terceros = []

    grupos.each do |grupo|
      tabla = grupo.selecciones.ordenadas_por_clasificacion
      clasificaciones[grupo.id] = tabla
      terceros << tabla[2] if tabla.size >= 3
    end

    mejores_terceros = terceros.sort_by do |equipo|
      [
        -equipo.puntos,
        -equipo.diferencia_goles,
        -equipo.goles_favor
      ]
    end.first(8)

    [grupos, clasificaciones, mejores_terceros]
  end

  def self.clasificados_para_eliminatoria
    grupos, clasificaciones, mejores_terceros = clasificacion_mundial
    clasificados = []

    grupos.each do |grupo|
      tabla = clasificaciones[grupo.id]
      clasificados << tabla[0] if tabla[0]
      clasificados << tabla[1] if tabla[1]
    end

    clasificados + mejores_terceros
  end
  private
  def limite_de_equipos_por_grupo
    return unless grupo_id.present?

    query = Seleccion.where(grupo_id: grupo_id)
    query = query.where.not(id: id) if persisted?

    if query.count >= 4
      errors.add(:grupo_id, "ya tiene 4 selecciones. Cada grupo puede tener máximo 4 equipos.")
    end
  end
end
