Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, path: 'account', skip: [:sessions], path_names: { cancel: 'deactive' }
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    match 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end

  root to: "pages#show", page: "home"
  
  resources :projects, :groups
  
  resources :accounts, only: [:index, :show] do
    resources :user_roles, :path => "roles", except: [:edit, :update]
  end
  
end