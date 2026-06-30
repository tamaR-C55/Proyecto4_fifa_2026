Rails.application.routes.draw do
  resources :grupos
  resources :selecciones

  resources :resultados, only: [:index]

  resources :partidos do
    collection do
      post :generar
      post :generar_eliminatoria
      post :reiniciar_eliminatoria
    end
  end
  get "clasificaciones", to: "clasificaciones#index"

  root "grupos#index"
end