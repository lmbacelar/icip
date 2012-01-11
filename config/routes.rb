Icip::Application.routes.draw do

  ### Sessions ###
  root to: 'sessions#new'
  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  resources :sessions, only: :create
  ### Users ###
  resources :users, except: :show
  ### Aircrafts, Konfigurations, Zones and Items ###
  resources :aircrafts, shallow: true do
    resources :konfigurations, shallow: true do
      resources :zones, shallow: true do
        resources :items
      end
    end
  end
  ### Parts, Protocols and Checkpoints
  resources :parts, shallow: true do
    get 'page/:page', action: :index, on: :collection
    resources :protocols, shallow: true do
      resources :checkpoints
    end
  end
  get 'parts_autocomplete' => 'parts#parts_autocomplete', as: :parts_autocomplete
  get 'subparts_autocomplete' => 'parts#subparts_autocomplete', as: :subparts_autocomplete
  ### Inspections, Tascs and Closings
  resources :inspections do
    get 'page/:page', action: :index, on: :collection
    resources :items, only: [] do
      resources :tascs, shallow: true, except: :index
    end
  end
  resources :tascs, shallow: true, only: :index do
    get 'page/:page', action: :index, on: :collection
    resources :closings
  end
  ### Images and Locations
  resources :images, shallow: true, except: [:edit, :update] do
    resources :locations, except: :show
  end
end
