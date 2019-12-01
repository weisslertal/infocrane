Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :etl, only: [] do
    collection do
      post :load
    end
  end

  resources :sensor_event, only: [] do
    collection do
      get :altitude_at_range
    end
  end

  resources :crane, only: [] do
    collection do
      get :data_at_time
    end
  end
end
