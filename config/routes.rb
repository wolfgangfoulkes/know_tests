Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }
  resources :users, :only => [:show]

  resources :events, :only => [:show, :new, :create, :destroy, :edit, :update, :index] do

    collection do #events/
      post 'filtered'
    end

    member do #event/:id/ with :id passed in params[:id]
    end

    resources :comments, :only => [:show, :create, :destroy], module: :events
    resources :questions, :only => [:create, :destroy]

    post 'follow', to: 'socializations#follow'
    post 'unfollow', to: 'socializations#unfollow'
  end

  resources :questions, :only => [:show] do
    resources :comments, :only => [:show, :create, :destroy], module: :questions
  end

  #post ':controller(/filtered)', action: 'filtered'
  
  resources :tags, :only => [:show, :create, :destroy]

  get 'schedule/:action', controller: 'schedule'
  # schedule_*_path
  get 'schedule/list'
  get 'schedule/calendar'
  # schedule_path
  get 'schedule/list', as: 'schedule' 
  get 'schedule/calendar', as: 'calendar'
  # redirects
  get '/calendar', to: redirect('schedule/calendar')
  get '/schedule', to: redirect('schedule/list') 
  
  get '/activities', to: 'static_pages#activities', as: 'activities'
  root 'static_pages#home'

  # ----- error handling
  get '/access_error', to: 'errors#access'
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  # - make sure this is the last route, http://jerodsanto.net/2014/06/a-step-by-step-guide-to-bulletproof-404s-on-rails/
  get "*any", via: :all, to: "errors#not_found"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
