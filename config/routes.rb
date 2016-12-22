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
    resources :campaigns, path: 'c', except: [:index] do
      resources :posts, path: 'p', except: [:index, :edit, :update]
    end
  end

  # Marketing
  get 'marketing/index'

  # Roots
  authenticated :user do
    root to: redirect('/o'), as: :authenticated_root
  end

  root 'marketing#index'
end
