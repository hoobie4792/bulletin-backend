Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, :only => [:show, :update, :destroy]
      resources :posts, :only => [:index, :show, :create, :update, :destroy] do 
        delete '/remove-like', to: 'likes#destroy'
      end
      resources :comments, :only => [:create, :update, :destroy]
      resources :likes, :only => [:create]
      resources :shares, :only => [:create]
      resources :messages, :only => [:index, :create, :destroy]
      resources :news_sources, :only => [:index]
      resources :interests, :only => [:index]
      resources :user_news_sources, :only => [:create]
      resources :user_interests, :only => [:create]

      post '/login', :to => 'sessions#create'
      post '/get-username', :to => 'sessions#get_username'
      post '/signup', :to => 'users#create'
      post '/update-user', :to => 'users#update'
    end
  end
end
