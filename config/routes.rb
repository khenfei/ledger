Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'authenticated_only', to: 'authenticated_only#index'
  root to: 'home#index'
end
