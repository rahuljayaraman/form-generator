BootstrapData::Application.routes.draw do

  resources :sources


  get "pages/home"
  root :to => 'pages#home'

  resources :user_sessions, as: :user_sessions
  resources :users, as: :users
    
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
end
