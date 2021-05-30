Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'reviewlize#home'
  get 'search', to: "reviewlize#index", as: :search
  get 'show', to: "reviewlize#show", as: :show_product
end
