Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "static_pages#home"
  resources :play, only: :show do
    post "guess", on: :member
    resources :scores, only: [:index, :new, :create]
  end
  resources :scores, only: [:show]
end
