require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root "pages#home"

  get "dashboard", to: "dashboard#show", as: :dashboard

  resources :jobs do
    resources :applications, only: %i[index show create], module: :jobs
  end

  resources :applications, only: %i[index show update] do
    member do
      patch :update_status
      post :recalculate_ats
      get :ats_status
    end
  end

  resource :resume, only: %i[show create update]
  resources :notifications, only: %i[index update] do
    collection do
      patch :mark_all_read
    end
  end

  namespace :admin do
    get "dashboard", to: "dashboard#show"
  end

  namespace :recruiter do
    get "dashboard", to: "dashboard#show"
    resources :applications, only: %i[index show update]
    resources :pipeline, only: %i[index], controller: "pipeline"
  end

  namespace :candidate do
    get "dashboard", to: "dashboard#show"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
