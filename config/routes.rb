DocIT::Application.routes.draw do
  

  # The priority is based upon order of creation:
  # first created -> highest priority.
  #match 'photos/show' => 'photos#show', :via => :get
#  match 'twilio/voice' => 'twilio#voice', :via => :post
#  match 'twilio/make_call' => 'twilio#make_call', :via => :post
  
  match 'home/verify' => 'home#number_verification', :via => :post
  
  namespace :api do
    devise_scope :user do
      post 'sessions' => 'sessions#create', :as => 'login'
      delete 'sessions' => 'sessions#destroy', :as => 'logout'
    end
    get  '/api/call_log(.:format)', :to => 'api/call_log#index', :as => 'api_call_log_index'
    delete  '/api/call_log/:id(.:format)', :to => 'api/call_log#destroy', :as => 'api_call_log'
    resources :call_log
  end
devise_scope :user do
   get 'users/:id/signup', :to => 'guest_registrations#new', :as => 'signup_new'
   post 'users/:id/registration', :to => 'guest_registrations#create', :as => 'guest_registration'
 end
  devise_for :users, :controllers => {:registrations => "registrations"}


  match '/call_logs' => 'call_log#index', :via => :get
#  match 'home/makecall' => 'home#makecall', :via => :post
#  match 'home/reminder' => 'home#reminder', :via => :post
#  match 'home/goodbye' => 'home#goodbye', :via => :post
#  
#  
#  match 'home/directions' => 'home#directions', :via => :post
  
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
#  devise_scope :user do
#   root :to => 'devise/registrations#edit'
#  end
  root to: 'home#index'
  #temporary added for api urls testing ...
  match '/:controller(/:action(/:id))', :controller => /api\/[^\/]+/, :via => [:get, :post]
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
