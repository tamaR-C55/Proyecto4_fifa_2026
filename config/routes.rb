Rails.application.routes.draw do
  resources :grupos
  resources :selecciones
  root "grupos#index"
end