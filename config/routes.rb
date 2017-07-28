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

  # Facebook Tokens
  resources :facebook_tokens, except: [:index, :new, :edit] do
    post :create_or_update, on: :collection
  end

  # Posts
  resources :posts, except: [:edit, :update] do
    resources :comments, except: [:new, :edit, :show, :create, :destroy]
    resources :reactions, except: [:new, :edit, :show, :create, :destroy]
    resources :shares, except: [:new, :edit, :show, :create, :destroy]
    get :interactions
    get :sync_status
    post :flag_random_interaction
    post :sync_post
  end

  # # Organzations, Campaigns, & Posts
  # resources :organizations, path: 'o' do
  #   resources :invitations, except: [:index, :show, :edit]
  #   resources :campaigns, path: 'c', except: [:index] do
  #     get :interactions
  #     post :flag_random_interaction
  #     resources :posts, path: 'p', except: [:index, :edit, :update] do
  #       resources :comments, except: [:new, :edit, :show, :create, :destroy]
  #       resources :reactions, except: [:new, :edit, :show, :create, :destroy]
  #       resources :shares, except: [:new, :edit, :show, :create, :destroy]
  #       get :interactions
  #       get :sync_status
  #       post :flag_random_interaction
  #       post :sync_post
  #     end
  #   end
  # end

  # Marketing
  get 'marketing/index'

  # Roots
  authenticated :user do
    root to: redirect('/posts'), as: :authenticated_root
  end

  root 'marketing#index'
end
