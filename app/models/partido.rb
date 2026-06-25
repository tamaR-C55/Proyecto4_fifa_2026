class Partido < ApplicationRecord
  FASES = %w[grupos eliminatoria].freeze
  RONDAS_ELIMINATORIA = %w[dieciseisavos octavos cuartos semis tercer_lugar final].freeze

  belongs_to :grupo, optional: true

  belongs_to :seleccion_a,
             class_name: "Seleccion",
             foreign_key: "seleccion_a_id"

  belongs_to :seleccion_b,
             class_name: "Seleccion",
             foreign_key: "seleccion_b_id"

  scope :grupos, -> { where(fase: "grupos") }
  scope :eliminatoria, -> { where(fase: "eliminatoria") }

  validates :seleccion_a_id, presence: true
  validates :seleccion_b_id, presence: true
  validates :fase, presence: true, inclusion: { in: FASES }
  validates :ronda, inclusion: { in: RONDAS_ELIMINATORIA }, allow_nil: true
  validates :orden, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :penales_a, :penales_b,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validate :selecciones_diferentes
  validate :grupo_requerido_en_fase_de_grupos
  validate :datos_de_eliminatoria

  private

  def grupo_requerido_en_fase_de_grupos
    return unless fase == "grupos" && grupo_id.blank?

    errors.add(:grupo_id, "es obligatorio para la fase de grupos")
  end

  def datos_de_eliminatoria
    return unless fase == "eliminatoria"

    errors.add(:ronda, "es obligatoria para la fase eliminatoria") if ronda.blank?
    errors.add(:orden, "es obligatorio para la fase eliminatoria") if orden.blank?

    return unless jugado && goles_a == goles_b

    if penales_a.blank? || penales_b.blank?
      errors.add(:base, "Si el partido termina empatado, debes registrar los penales")
    elsif penales_a == penales_b
      errors.add(:base, "Los penales deben definir un ganador")
    end
  end

  def selecciones_diferentes
    if seleccion_a_id == seleccion_b_id
      errors.add(:seleccion_b_id, "debe ser diferente de la selección A")
    end
  end

  public

  def eliminatoria?
    fase == "eliminatoria"
  end

  def marcador
    if eliminatoria? && jugado && goles_a == goles_b && penales_a.present? && penales_b.present?
      "#{goles_a}-#{goles_b} (#{penales_a}-#{penales_b} pen.)"
    else
      "#{goles_a}-#{goles_b}"
    end
  end

  def ganador
    return unless jugado

    if goles_a > goles_b
      seleccion_a
    elsif goles_b > goles_a
      seleccion_b
    elsif eliminatoria?
      return seleccion_a if penales_a.to_i > penales_b.to_i
      return seleccion_b if penales_b.to_i > penales_a.to_i
    end
  end

  def perdedor
    return unless jugado

    if ganador == seleccion_a
      seleccion_b
    elsif ganador == seleccion_b
      seleccion_a
    end
  end

  def procesar_avance_eliminatoria!
    return unless eliminatoria? && jugado

    Partido.avanzar_desde(self)
  end

  def self.generar_eliminatoria!
    clasificados = Seleccion.clasificados_para_eliminatoria
    return false if clasificados.size < 32
    return true if eliminatoria.exists?

    clasificados.each_slice(2).with_index(1) do |(seleccion_a, seleccion_b), indice|
      create!(
        fase: "eliminatoria",
        ronda: "dieciseisavos",
        orden: indice,
        seleccion_a: seleccion_a,
        seleccion_b: seleccion_b
      )
    end

    true
  end

  def self.avanzar_desde(partido)
    return unless partido.eliminatoria?

    sibling = where(fase: "eliminatoria", ronda: partido.ronda)
              .where(orden: partido.orden.to_i.odd? ? partido.orden.to_i + 1 : partido.orden.to_i - 1)
              .first

    return unless sibling&.jugado

    ordenados = [partido, sibling].sort_by(&:orden)
    ganadores = ordenados.map(&:ganador).compact
    perdedores = ordenados.map(&:perdedor).compact

    case partido.ronda
    when "dieciseisavos", "octavos", "cuartos"
      siguiente = siguiente_ronda(partido.ronda)
      return unless siguiente && ganadores.size == 2

      crear_partido_eliminatoria!(
        ronda: siguiente,
        orden: (partido.orden.to_i + 1) / 2,
        seleccion_a: ganadores.first,
        seleccion_b: ganadores.last
      )
    when "semis"
      return unless ganadores.size == 2 && perdedores.size == 2

      crear_partido_eliminatoria!(
        ronda: "final",
        orden: 1,
        seleccion_a: ganadores.first,
        seleccion_b: ganadores.last
      )

      crear_partido_eliminatoria!(
        ronda: "tercer_lugar",
        orden: 1,
        seleccion_a: perdedores.first,
        seleccion_b: perdedores.last
      )
    end
  end

  def self.crear_partido_eliminatoria!(ronda:, orden:, seleccion_a:, seleccion_b:)
    partido = find_or_initialize_by(fase: "eliminatoria", ronda: ronda, orden: orden)
    partido.assign_attributes(
      seleccion_a: seleccion_a,
      seleccion_b: seleccion_b,
      grupo_id: nil
    )
    partido.save!
    partido
  end

  def self.siguiente_ronda(ronda)
    index = RONDAS_ELIMINATORIA.index(ronda)
    return unless index

    RONDAS_ELIMINATORIA[index + 1]
  end

  def self.podio
    final = find_by(
      fase: "eliminatoria",
      ronda: "final",
      jugado: true
    )

    tercer = find_by(
      fase: "eliminatoria",
      ronda: "tercer_lugar",
      jugado: true
    )

    return nil unless final && tercer

    {
      campeon: final.ganador,
      subcampeon: final.perdedor,
      tercer_lugar: tercer.ganador
    }
  end
end