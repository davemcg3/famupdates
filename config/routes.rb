Rails.application.routes.draw do
  devise_for :users
  resources :posts
  resources :statuses
  get '/profiles/friends', to: 'profiles#friends', as: :logged_in_homepage
  resources :profiles, param: :username
  resources :relationships, only: [:create, :destroy]
  resources :exclusions, only: [:create, :destroy]
  get 'profiles/load_profile/:id', to: 'profiles#load_profile', as: 'load_profile'
  get '/profiles/:id/statuses', to: 'profiles#statuses', as: :past_statuses
  get '/site', to: 'site#index', as: :logged_out_homepage
  get '/site/terms_of_use', to: 'site#terms_of_use', as: :terms_of_use
  get '/site/privacy_policy', to: 'site#privacy_policy', as: :privacy_policy
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/user' => "profiles#friends", :as => :user_root
  root 'site#index'
end
