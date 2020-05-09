Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'voters', to: 'voters#sign'
  get 'public-key', to: 'voters#public_key'
end
