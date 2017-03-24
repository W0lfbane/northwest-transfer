class RegistrationsController < Devise::RegistrationsController
# For what purpose are these here?
#    prepend_before_action :require_no_authentication, only: :cancel
#    prepend_before_action :authenticate_scope!
    before_action :authorize_resource

    protected
    
        def authorize_resource
            authorize resource
        end
end