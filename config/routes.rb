# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  devise_for :users, skip: [:sessions], path_names: { cancel: 'deactive', sign_up: 'new' }, controllers: { registrations: "registrations" }

  resources :users, only: [:index, :show] do
    resources :user_roles, :path => "roles", except: [:edit, :update]
  end

  devise_scope :user do
    get 'account', to: 'users#show', as: :account
    get 'account/edit', to: 'registrations#edit', as: :edit_account
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    match 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end
  
  as :project do
    get '/projects/calendar', to: 'calendar#index', as: :projects_calendar, page: 'index', resources: {projects: Project}
  end

  resources :projects, :groups
  
  as :project do
    get '/account/schedule', to: 'projects#index', as: :schedule
    get '/account/projects', to: 'projects#index', as: :user_projects
    get '/projects/:id/:step', to: 'projects#edit', step: :pending, as: :edit_project_step
  end

  as :group do
    get '/account/groups', to: 'groups#index', as: :user_groups
  end
end