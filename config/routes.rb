Rails.application.routes.draw do
  resources :grupos
  resources :selecciones

  resources :partidos do
    collection do
      post :generar
      post :generar_eliminatoria
    end
  end
  get "clasificaciones", to: "clasificaciones#index"

  root "grupos#index"
end