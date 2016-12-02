Rails.application.routes.draw do
  require 'sidekiq/web'

  # Sidekiq Monitoring
  mount Sidekiq::Web => '/sidekiq'

  # Users
  devise_for :users, path: 'account'

  # Authentications
  resources :authentications, except: [:new, :edit, :show]

  # Organzations, Campaigns, & Posts
  resources :organizations, path: 'o' do
    resources :campaigns do
      resources :posts, except: [:edit, :update]
    end
  end

  # Marketing Pages
  get 'marketing/index'

  # Home Pages
  root 'marketing#index'
end
