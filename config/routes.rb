Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'dummy', to: 'dummy#index'
  root to: 'home#index'
end
