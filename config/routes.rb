BootstrapData::Application.routes.draw do

  match "wizard/step1" => "wizard#step1", as: :wizard_step1
  match "wizard/step2" => "wizard#step2", as: :wizard_step2


  get "wizard/step3"

  get "wizard/step4"

  get "wizard/step5"

  resources :sources, :forms, :reports, :form_renderers, :applications, :roles

  root :to => 'pages#home'
  mount Resque::Server, :at => "/resque"

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
  match 'applications/invite_users/:id' => 'applications#invite', as: :invite_users
  match 'users/invite_users/' => 'users#invite_builder', as: :invite_builder
  match 'applications/:id/members' => 'applications#members', as: :application_members
  match 'select' => 'users#select_application', as: :select_application
end
