require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users

  namespace :api, path: '/', defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :songs do
        resources :song_tracks
      end

      resources :song_tracks

      resources :users, except: [:index] do
        resources :songs do
          resources :song_tracks
        end
      end

      resources :sessions, only: [:create, :destroy]
    end
  end
end
