Rails.application.routes.draw do
  resources :etl, only: [] do
    collection do
      post :load
    end
  end

  resources :sensor_event, only: [] do
    collection do
      get :altitude_from_range
    end
  end
end
