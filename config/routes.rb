Rails.application.routes.draw do
  

  devise_for :users, :controllers => { registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }
  resources :users, :only => [:show]

  resources :events, :only => [:show, :create, :destroy, :edit, :update, :index] do
    collection do #events/
    end
    member do #event/:id/ with :id passed in params[:id]
      get 'add_to_calendar'
    end
    post 'follow', to: 'socializations#follow'
    post 'unfollow', to: 'socializations#unfollow'
  end
  
  resources :tags, :only => [:show, :create, :destroy]

  get 'schedule/:action', controller: 'schedule'
  get '/schedule', to: redirect('schedule/list'), as: 'schedule' #as: schedule defines schedule_path to refer to this action
  
  root 'static_pages#home'

  get 'event_test', to: 'static_pages#event_test'


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
