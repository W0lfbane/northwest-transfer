# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  devise_for :users, skip: [:sessions, :registrations], controllers: { invitations: "invitations" }

  devise_scope :user do
    resources :users
    
    delete 'users/:id/deactivate',  to: 'users#cancel', as: :deactivate_user
    patch 'users/:id/status',  to: 'users#resource_state_change', as: :user_resource_state_change
    patch 'users/:id/role',  to: 'users#resource_role_change', as: :user_resource_role_change
    get 'account', to: 'users#show', as: :account
    get 'account/edit', to: 'users#edit', as: :edit_account
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    match 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end

  get 'projects/calendar', to: 'calendar#index', as: :projects_calendar, resources: { projects: 'Project' }
  resources :roles
  resources :groups, :projects, :documents, :tasks do
    patch 'status', action: :resource_state_change, as: :resource_state_change
  end

  as :project do
    get 'account/schedule', to: 'projects#schedule_index', as: :schedule
    get 'account/projects', to: 'projects#user_projects_index', as: :user_projects
  end

  as :group do
    get 'account/groups', to: 'groups#user_groups_index', as: :user_groups
  end

  # Nested routes with multiple or unknown parents
  scope as: :nested do
    scope '/:resource_controller' do
      scope '/:resource_id'do
        resources :tasks
        resources :notes
        resources :roles
        resources :documents

        scope module: :nested do
          resources :users do
            patch 'role', action: :resource_role_change, as: :resource_role_change
          end
        end
      end
    end
  end
end