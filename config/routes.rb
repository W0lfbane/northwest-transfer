# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  devise_for :users, skip: [:sessions], path_names: { cancel: 'deactive', sign_up: 'new' }, controllers: { registrations: "registrations", invitations: "invitations" }

  resources :users, only: [:index, :show]

  devise_scope :user do
    get 'account', to: 'users#show', as: :account
    get 'account/edit', to: 'registrations#edit', as: :edit_account
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    match 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end

  get '/projects/calendar', to: 'calendar#index', as: :projects_calendar, resources: { projects: Project }

  resources :groups, :projects

  resources :projects do
    resource :documents
  end
  # Nested routes with multiple or unknown parents
  scope '/:resource_controller' do
    scope '/:resource_id' do
      resources :tasks
      resources :notes
      resources :roles
      resources :documents

      patch '/status', controller: :resource_controller, action: :resource_state_change, as: :resource_state_change
      patch '/role', controller: :resource_controller, action: :resource_role_change, as: :resource_role_change
    end
  end

  as :project do
    get '/account/schedule', to: 'projects#schedule_index', as: :schedule
    get '/account/projects', to: 'projects#user_projects_index', as: :user_projects
  end

  as :group do
    get '/account/groups', to: 'groups#user_groups_index', as: :user_groups
  end
end
