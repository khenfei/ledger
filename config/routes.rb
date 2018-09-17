Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  resources :expenses
  post 'expenses/data', to: 'expenses#data', as: 'expenses_data'
  get 'authenticated_only', to: 'authenticated_only#index'
  root to: 'home#index'
end
