Huginn::Application.routes.draw do
  resources :agents do
    member do
      post :run
      post :handle_details_post
      put :leave_scenario
      delete :remove_events
    end

    collection do
      post :propagate
      get :type_details
      get :event_descriptions
    end

    resources :logs, :only => [:index] do
      collection do
        delete :clear
      end
    end

    resources :events, :only => [:index]
  end

  resource :diagram, :only => [:show]

  resources :events, :only => [:index, :show, :destroy] do
    member do
      post :reemit
    end
  end

  resources :scenarios do
    collection do
      resource :scenario_imports, :only => [:new, :create]
    end

    member do
      get :share
      get :export
    end

    resource :diagram, :only => [:show]
  end

  resources :user_credentials, :except => :show

  resources :services, :only => [:index, :destroy] do
    member do
      post :toggle_availability
    end
  end

  get "/worker_status" => "worker_status#show"

  post "/users/:user_id/update_location/:secret" => "user_location_updates#create"

  match  "/users/:user_id/web_requests/:agent_id/:secret" => "web_requests#handle_request", :as => :web_requests, :via => [:get, :post, :put, :delete]
  post "/users/:user_id/webhooks/:agent_id/:secret" => "web_requests#handle_request" # legacy

# To enable DelayedJobWeb, see the 'Enable DelayedJobWeb' section of the README.
#  get "/delayed_job" => DelayedJobWeb, :anchor => false

  devise_for :users, :sign_out_via => [ :post, :delete ]
  get '/auth/:provider/callback', to: 'services#callback'

  get "/about" => "home#about"
  root :to => "home#index"
end
