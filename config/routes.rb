Rails.application.routes.draw do
  resources :reviews
  resources :books do
    resources :reviews, only: [:new, :create]
  end
  resources :users
  get "up" => "rails/health#show", as: :rails_health_check
  
end
