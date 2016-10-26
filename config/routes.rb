Rails.application.routes.draw do
  get 'marketing/index'

  root 'marketing#index'
  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
end
