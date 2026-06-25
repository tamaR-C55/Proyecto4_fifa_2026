class ResultadosController < ApplicationController

  def index
    @podio = Partido.podio
  end

end