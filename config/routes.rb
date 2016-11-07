Rails.application.routes.draw do
  resources :organizations, except: [:index]
  resources :posts, except: [:edit, :update]
  resources :authentications, except: [:new, :edit, :show]
  devise_for :users
  get 'marketing/index'

  root 'marketing#index'
  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
end
