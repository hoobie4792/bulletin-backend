Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, :only => [:show, :update, :destroy]
      resources :posts, :only => [:index, :show, :create, :update, :destroy] do 
        delete '/remove_like', to: 'likes#destroy'
      end
      resources :comments, :only => [:create, :update, :destroy]
      resources :likes, :only => [:create]
      resources :shares, :only => [:create]
      resources :messages, :only => [:index, :create, :destroy]

      post '/login', :to => 'sessions#create'
      post '/signup', :to => 'users#create'
      post '/update_user', :to => 'users#update'
    end
  end
end
