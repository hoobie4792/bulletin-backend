Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, :only => [:show, :destroy]
      resources :posts, :only => [:index, :show, :create, :update, :destroy] do 
        delete '/remove-like', to: 'likes#destroy'
      end
      resources :comments, :only => [:create, :update, :destroy]
      resources :likes, :only => [:create]
      resources :shares, :only => [:create]
      resources :follows, :only => [:create]
      resources :follow_requests, :only => [:create, :update, :destroy]
      resources :messages, :only => [:create]
      resources :news_sources, :only => [:index, :show]
      resources :interests, :only => [:index, :show]
      resources :user_news_sources, :only => [:create]
      resources :user_interests, :only => [:create]
      resources :notifications, :only => [:index]
      resources :conversations, :only => [:index, :create]

      post '/login', :to => 'sessions#create'
      post '/get-username', :to => 'sessions#get_username'
      post '/signup', :to => 'users#create'
      post '/update-user', :to => 'users#update'
      post '/get-posts-by-tag', :to => 'tags#get_posts'
      post '/search-users', :to => 'users#search_users'
      post '/create-shared-post', :to => 'posts#create_shared_post'
      get '/get-interests-and-news-sources', :to => 'users#get_interests_and_news_sources'
      post '/accept-follow-request', :to => 'follow_requests#accept_request'
      post '/deny-follow-request', :to => 'follow_requests#deny_request'
    end
  end
end
