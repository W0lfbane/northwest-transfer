# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  devise_for :users, skip: [:sessions], path_names: { cancel: 'deactive', sign_up: 'new' }, controllers: { registrations: "registrations" }

  resources :users, only: [:index, :show] do
    resources :user_roles, :path => "roles", except: [:edit, :update]
  end

  devise_scope :user do
    get 'account', to: 'users#show', as: :account
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    match 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end

  resources :projects, :groups

  as :project do
    get '/projects/:id/pending', to: 'projects#edit', step: :pending, as: :edit_pending_project
    get '/projects/:id/en_route', to: 'projects#edit', step: :en_route, as: :edit_en_route_project
    get '/projects/:id/in_progress', to: 'projects#edit', step: :in_progress, as: :edit_in_progress_project
  end
end