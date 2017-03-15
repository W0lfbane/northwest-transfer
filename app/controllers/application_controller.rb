class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  protect_from_forgery with: :exception
  
  def set_current_user
    User.current = current_user
  end
end
