Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV.fetch('ADMIN_USERNAME') { 'admin' } && password == ENV.fetch('ADMIN_PASSWORD') { 'admin' }
  end
  mount Sidekiq::Web => '/sidekiq'
  root 'home#index'
  resources :apps, only: [:index, :create, :destroy] do
    collection do
      post :change_apns
    end
  end
  resources :mobile_devices, only: [:index, :create, :destroy]
  resources :push_notifications, only: [:create]
  resources :accesses, only: [:index]
end
