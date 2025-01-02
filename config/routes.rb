
Rails.application.routes.draw do
  require "sidekiq/web"

  mount Sidekiq::Web => "/sidekiq"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get "news", to: "news_articles#index", as: "news_articles_index"
      get "news/:id", to: "news_articles#show", as: "news_article_show"
      get "publishers", to: "publishers#index", as: "publishers_index"
      get "publishers/:id", to: "publishers#show", as: "publisher_show"
      get "publishers/:slug/news", to: "publisher_news#index", as: "publisher_news_index"
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
