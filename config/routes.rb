Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  scope :expenses do
    get 'reports', to: 'reports#index', as: 'expenses_reports'
    get 'reports/category_data', to: 'reports#category_data'
    get 'reports/monthly_data', to: 'reports#monthly_data'
  end 
  resources :expenses
  post 'expenses/data', to: 'expenses#data', as: 'expenses_data'
  get 'authenticated_only', to: 'authenticated_only#index'
  root to: 'home#index'
end
