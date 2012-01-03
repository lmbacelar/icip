Icip::Application.routes.draw do

  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  resources :users
  resources :sessions

  root to: 'sessions#new'

  resources :aircrafts, shallow: true do
    resources :konfigurations, shallow: true do
      resources :zones, shallow: true do
        resources :items
      end
    end
  end
  resources :parts, shallow: true do
    get 'page/:page', action: :index, on: :collection
    resources :protocols, shallow: true do
      resources :checkpoints
    end
  end
  get 'parts_autocomplete' => 'parts#parts_autocomplete', as: :parts_autocomplete
  get 'subparts_autocomplete' => 'parts#subparts_autocomplete', as: :subparts_autocomplete

  resources :inspections do
    get 'page/:page', action: :index, on: :collection
  end

  get 'inspections/:inspection_id/items/:item_id/tascs/new' => 'tascs#new', as: :new_inspection_item_tasc
  post 'inspections/:inspection_id/items/:item_id/tascs/new' => 'tascs#create', as: :inspection_item_tascs
  get 'tascs/:id' => 'tascs#show', as: :tasc
  get 'tascs/:id/edit' => 'tascs#edit', as: :edit_tasc
  put 'tascs/:id' => 'tascs#update', as: :tasc
  delete 'tascs/:id' => 'tascs#destroy', as: :tasc

  resources :images, shallow: true do
    resources :locations
  end


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
  # match ':controller(/:action(/:id(.:format)))'
end
