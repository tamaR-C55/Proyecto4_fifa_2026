class Seleccion < ApplicationRecord
  # Nombre exacto de la tabla en la base de datos
  self.table_name = "seleccions"

  belongs_to :grupo

  validates :pais, presence: true, uniqueness: true
  validates :puntos, :goles_favor, :goles_contra, :diferencia_goles,
            numericality: { greater_than_or_equal_to: 0 }

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
end
