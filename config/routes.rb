Rails.application.routes.draw do


  get 'finders/finder'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    resource :relationships, only: [:create, :destroy]
    get "finder" => "finders#finder"
  end

  get "search" => "searches#search"
  get "tagsearch" => "tagsearches#tagsearch"
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]
  resources :groups, except:[:destroy] do
    resource :group_users,  only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end