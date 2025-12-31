Rails.application.routes.draw do
  resources :services
  resources :clients
  resource :session
  resources :passwords, param: :token
  resources :reviews
  get "pages/index"
  get "shop/index"
  resources :products
  resources :payments, only: [ :create ]
  resources :contacts, only: [ :index, :destroy ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#index"
  get "/about" => "pages#about"
  get "contact", to: "pages#contact", as: :contact_page
  get "bookings", to: "contacts#bookings", as: :bookings_list
  delete "bookings/:id", to: "contacts#delete_booking", as: :delete_booking

  post "contacts/create", to: "pages#create_contact", as: :create_contact_msg
  post "bookings/create", to: "pages#create_booking", as: :create_booking

  post "/add_to_cart/:id" => "shop#add_to_cart", as: :add_to_cart
  post "/remove_from_cart/:id" => "shop#remove_from_cart", as: :remove_from_cart
  get "/shopping_cart" => "shop#shopping_cart"
  post "/confirm_order" => "shop#confirm_order", as: :confirm_order
  post "/shop/update_delivery_fee", to: "shop#update_delivery_fee", as: :update_delivery_fee


  resources :orders do
    member do
      post :prepare_order
      post :shipped
      post :delivered
      post :mark_as_cancelled # O mark_as_cancelled si le cambiaste el nombre
    end
  end
  # get "/prepare_order/:id" => "orders#prepare_order"
  # get "/shipped/:id" => "orders#shipped"
  # get "/delivered/:id" => "orders#delivered"
  # get "/cancelled/:id" => "orders#cancelled"

  get "order_success", to: "orders#success", as: :order_success
  get "cancel_cart", to: "orders#cancel", as: :cancel_cart
  get "/order_status_check/:id", to: "orders#order_status_check"

  get "/control_panel", to: "pages#control_panel", as: :control_panel
end
