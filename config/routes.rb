Rails.application.routes.draw do
  resources :reviews
  resources :books
  resources :users
  get "up" => "rails/health#show", as: :rails_health_check
  
end
