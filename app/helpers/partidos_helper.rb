module PartidosHelper
	def formato_marcador(partido)
		partido.marcador
	end

	def nombre_seleccion(partido, lado)
		partido.public_send("seleccion_#{lado}")&.pais || "Selección eliminada"
	end

	def etiqueta_ronda(ronda)
		{
			"dieciseisavos" => "Dieciseisavos de final",
			"octavos" => "Octavos de final",
			"cuartos" => "Cuartos de final",
			"semis" => "Semifinales",
			"tercer_lugar" => "Partido por el tercer lugar",
			"final" => "Final"
		}[ronda] || ronda.to_s.humanize
	end
end
