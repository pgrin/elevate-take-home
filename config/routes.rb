Rails.application.routes.draw do
  namespace :api do
    resource :sessions, only: [:create]
    resource :user, only: [:create, :show] do
      resources :game_events, only: [:create]
    end
  end
end
