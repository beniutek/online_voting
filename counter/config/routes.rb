Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "candidates#index"
  resources :votes, only: [:index, :create] do
    member do
      post :open
    end
  end
  resources :candidates, only: :index
  resources :results, only: :index
end
