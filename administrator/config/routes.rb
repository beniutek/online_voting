Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # post 'voters', to: 'voters#sign'

  resources :voters, only: [:index, :create] do
  end

  get 'public-key', to: 'home#public_key'
end
