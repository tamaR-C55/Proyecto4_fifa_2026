Rails.application.routes.draw do
  resources :grupos
  resources :selecciones

  resources :partidos do
    collection do
      post :generar
    end
  end

  root "grupos#index"
end