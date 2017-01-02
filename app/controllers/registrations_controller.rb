class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :authenticate_scope!
    prepend_after_action :authorize_resource, except: :index
    
    def index
        authorize User
        @users = policy_scope(User)
    end
    
    def show
        @user = resource
    end

    protected
    
        def authorize_resource
            authorize resource
        end
end