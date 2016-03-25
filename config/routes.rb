Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }
  resources :users, :only => [:show]

  resources :events, :only => [:show, :new, :create, :destroy, :edit, :update, :index] do

    collection do #events/
      post 'filtered'
      post 'search'
    end

    member do #event/:id/ with :id passed in params[:id]
    end

    post 'follow', to: 'socializations#follow'
    post 'unfollow', to: 'socializations#unfollow'
  end

  roles = [:default, :private, :public, :owner]
  resources :comments, :only => [:create, :destroy, :show] do
    roles.each do |role|
      patch "set_#{role}", on: :member, as: "set_#{role}"
    end
  end

  get 'comments#paginate', controller: "comments", action: "paginate"

  

  #post ':controller(/filtered)', action: 'filtered'
  
  resources :tags, :only => [:show, :create, :destroy]

  # ----- schedule

  # only json
  get 'schedule/list'

  # schedule_calendar_path
  get 'schedule/calendar'
  # schedule_path
  get 'schedule/calendar', as: 'schedule'
  # redirect for url
  get '/schedule', to: redirect('schedule/calendar') 
  # -------- #

  # ----- static_pages
  # these could easily be replaced with a url query 
  match '/feed',       controller: 'static_pages', action: 'feed',        via: [:get, :post], as: 'feed'
  match '/saved',      controller: 'static_pages', action: 'saved',       via: [:get, :post], as: 'saved'
  match '/activities', controller: 'static_pages', action: 'activities',  via: [:get, :post], as: 'activities'
  get '/activities/event/:id', to: 'static_pages#activity_list'
  
  root 'static_pages#feed'
  # -----

  # ----- error handling
  get '/access_error', to: 'errors#access'
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  # - make sure this is the last route, 
  # a-la http://jerodsanto.net/2014/06/a-step-by-step-guide-to-bulletproof-404s-on-rails/
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
