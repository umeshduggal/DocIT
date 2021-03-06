DocIT::Application.routes.draw do
  

  # The priority is based upon order of creation:
  # first created -> highest priority.
  #match 'photos/show' => 'photos#show', :via => :get
#  match 'twilio/voice' => 'twilio#voice', :via => :post
#  match 'twilio/make_call' => 'twilio#make_call', :via => :post
  
  
  
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
  
  match '/eula' => 'home#eula', :via => :get
  match '/contact-us' => 'home#contact_us', :via => :get, :as => :contact_us
  match '/about-us' => 'home#about_us', :via => :get, :as => :about_us
  match '/videos' => 'home#videos', :via => :get
  match '/info' => 'home#info_for_billers_coders', :via => :get,:as => :info_for_billers_coders
  match '/download_pdf' => 'home#download_pdf', :via => :get
  match '/download_android_app' => 'home#download_android_app', :via => :get
  match '/download_app' => 'home#download_app', :via => :get
  match '/verification/new' => 'home#verification_new', :via => :get, :as=> :verification_new
  match '/verification/resend' => 'home#resend_verification', :via => :post
  match '/verification/:user_token' => 'home#mobile_number_verification', :via => :get, :as=> :verification
  match '/send_mail' => 'home#send_mail', :via => :post
  match 'home/verify' => 'home#number_verification', :via => :post
  match 'billing_managers' => 'intended_recipients#index', :via => :get, :as => :billing_manager
  match 'billing_summaries' => 'billing_summaries#index', :via => :get, :as => :billing_summaries
  match 'user/:id' => 'intended_recipients#user_action', :via => :post, :as => :user_action
  resources :intended_recipients
  match '/call_logs' => 'call_log#index', :via => :get
  match '/call_log/:id/archive' => 'call_log#archive', :via => :post,:as => 'call_log_archive'
  match '/call_log/:id/review' => 'call_log#review', :via => :post,:as => 'call_log_review'
  match '/call_logs/:id' => 'call_log#show', :via => :get,:as => 'show_call_logs'
  match '/send-call-log/:id' => 'call_log#send_call_log', :via => :get, :as => :send_call_log
  match '/send_call_log_mail' => 'call_log#send_call_log_mail', :via => :post
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
