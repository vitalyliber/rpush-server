Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'
  resources :apps, only: [:index, :create, :destroy]
  resources :mobile_devices, only: [:create, :destroy]
  resources :push_notifications, only: [:create]
end
