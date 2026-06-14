module SeleccionesHelper
  # Genera el badge con el código de país y el nombre
  def badge_pais(seleccion)
    content_tag(:span, style: "display: inline-flex; align-items: center; gap: 6px;") do
      content_tag(:span, seleccion.codigo,
        style: "background:#0A1F44; color:#C9A84C; font-size:11px; font-weight:bold;
                padding:2px 7px; border-radius:4px; font-family: monospace;") +
      content_tag(:span, seleccion.pais)
    end
  end
end