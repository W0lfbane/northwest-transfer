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
    
    def new
        build_resource({})
        yield resource if block_given?
        respond_with resource
    end

    protected
    
        def authorize_resource
            authorize resource
        end
end