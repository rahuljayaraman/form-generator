BootstrapData::Application.routes.draw do

  resources :applications


  resources :sources, :forms, :reports, :form_renderers

  root :to => 'pages#home'

  resources :user_sessions, as: :user_sessions
  resources :users do
    member do
      get :activate
      put :confirm
    end
  end
    
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'view_reports/:id' => 'reports#view_report', :as => :view_reports
end
