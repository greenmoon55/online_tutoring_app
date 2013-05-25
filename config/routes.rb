OnlineTutoringApp::Application.routes.draw do
  root to: "static_pages#home"

  get "static_pages/about"
  resources :users do
    member do
      get :friends, :requests,:blocked_users,:my_rooms
      
    end
    resources :rooms
  end

  match '/users/:id/messages', to: 'users#messages', via: :get
  resources :sessions, only: [:new, :create, :destroy]
  resources :search_contents, only: [:create]
  resources :relationships, only: [:create, :destroy]
  
  resources :requests, only: [:create, :destroy]
  resources :messages, only: :create
  resources :blocked_relationships, only: [:create,:destroy]

  match '/refresh', to: 'sessions#refresh', via: :get

  match '/signup', to: 'users#new'
  #match '/signup/teacher', to: 'users#new_teacher', as: :teacher_signup
  match '/users/:id/full_role', to: 'users#full_role', via: :get, as: :full_role_user
  match '/signin', to: 'sessions#new', via: :get
  match '/signin', to: 'sessions#create', via: :post
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/search', to: 'search_contents#search'
  match '/search', to: 'search_contents#create', via: :post
  match '/requests/delete_request', to: 'requests#delete_request', via: :post
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
