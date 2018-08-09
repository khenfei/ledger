Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  get 'dummy', to: 'dummy#index'
  root to: 'welcome#index'
end
