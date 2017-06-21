Rails.application.routes.draw do
  require 'sidekiq/web'

  # Sidekiq Monitoring
  mount Sidekiq::Web => '/sidekiq'

  devise_scope :user do
    get 'account/social', to: 'users/registrations#social', as: 'social_accounts'
  end

  # Users
  devise_for :users, path: 'account', controllers: {
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Facebook Tokens
  resources :facebook_tokens, except: [:index, :new, :edit] do
    post :create_or_update, on: :collection
  end

  # Organzations, Campaigns, & Posts
  resources :organizations, path: 'o' do
    get :users
    resources :invitations, except: [:index, :show, :edit]
    resources :campaigns, path: 'c' do
      get :interactions
      resources :posts, path: 'p', except: [:index, :edit, :update] do
        resources :comments, except: [:new, :edit, :show, :create, :destroy]
        resources :reactions, except: [:new, :edit, :show, :create, :destroy]
        get :interactions
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
