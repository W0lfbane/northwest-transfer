class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :require_no_authentication, only: :cancel
    prepend_before_action :authenticate_scope!
    prepend_after_action :authorize_resource, except: :index

    protected
    
        def authorize_resource
            authorize resource
        end
end