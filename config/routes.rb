Rails.application.routes.draw do

  # Users
  devise_for :users, path: 'account'
  
  # Authentications
  resources :authentications, except: [:new, :edit, :show]

  # Organzations, Campaigns, & Posts
  resources :organizations, except: [:index] do
    resources :campaigns do
      resources :posts, except: [:edit, :update]
    end
  end

  # Marketing Pages
  get 'marketing/index'

  # Home Pages
  root 'marketing#index'
end
