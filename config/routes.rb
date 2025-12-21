Rails.application.routes.draw do
  get "shop/index"
  resources :orders
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "shop#index"
  post "/add_to_cart/:id" => "shop#add_to_cart", as: :add_to_cart
  post "/remove_from_cart/:id" => "shop#remove_from_cart", as: :remove_from_cart
  get "/shopping_cart" => "shop#shopping_cart"
  post "/confirm_order" => "shop#confirm_order", as: :confirm_order
  post "/shop/update_delivery_fee", to: "shop#update_delivery_fee", as: :update_delivery_fee

  get "/prepare_order/:id" => "orders#prepare_order"
  get "/shipped/:id" => "orders#shipped"
  get "/delivered/:id" => "orders#delivered"
end
