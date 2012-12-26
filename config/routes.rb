BootstrapData::Application.routes.draw do

  resources :sources, :forms, :reports

  root :to => 'pages#home'

  resources :user_sessions, as: :user_sessions
  resources :users, as: :users
    
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'view_reports/:id' => 'reports#view_report', :as => :view_reports
end
