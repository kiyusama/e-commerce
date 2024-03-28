Rails.application.routes.draw do
  get 'order_items/index'
  get 'order_items/show'
  get 'order_items/new'
  get 'order_items/create'
  get 'order_items/edit'
  get 'order_items/update'
  get 'order_items/destroy'
  devise_for :users, controllers: { sessions: 'sessions' }
  
  resource :homes, only: [:index]
  resources :products, only: [:index, :show]
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :destroy]
  resources :abouts, only: [:index]
  resources :orders, only: [:new, :create, :show, :edit, :update, :index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "homes#index"
end
