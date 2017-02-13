Rails.application.routes.draw do
  require 'sidekiq/web'

  # Sidekiq Monitoring
  mount Sidekiq::Web => '/sidekiq'

  # Users
  devise_for :users, path: 'account', controllers: {
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Network Tokens
  post 'network_tokens/set'

  # Organzations, Campaigns, & Posts
  resources :organizations, path: 'o' do
    resources :invitations, except: [:index, :show, :edit]
    resources :campaigns, path: 'c', except: [:index] do
      resources :posts, path: 'p', except: [:index, :edit, :update] do
        resources :comments, except: [:new, :edit, :show, :create, :destroy]
        resources :reactions, except: [:new, :edit, :show, :create, :destroy]
        get :sync_status
        post :sync_post
      end
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
