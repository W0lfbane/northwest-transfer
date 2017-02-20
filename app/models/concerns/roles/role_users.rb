module Roles::RoleUsers
    extend ActiveSupport::Concern
    
    included do
        after_initialize :build_all_role_methods
    end

    # Fetch all roles available to object, iterate through each and then dynamically define the method for said role
    def build_all_role_methods
        klass = self.class
        show_roles(klass).map { |role| create_role_method(role, klass) }
    end

    # Dynamically defines methods to fetch users of a specific role
    def create_role_method(role, object = self)
        object.send(:define_method, role.to_s.pluralize) do
            role_user = "@#{role}_users"

            # Fix this query, N+1 problem
            instance_variable_get(role_user) ? instance_variable_get(role_user) : 
                                                instance_variable_set( role_user, self.users.collect { |user| 
                                                                                    user if user.has_role?(role, self) }.compact )
        end
    end

    # Returns an array of strings that are existing roles on an object
    def show_roles(object = self)
        if object.respond_to?(:roles)
            @roles ||= object.roles.distinct.pluck(:name)
        elsif object.respond_to?(:find_roles)
            @roles ||= object.find_roles.distinct.pluck(:name)
        else
            false
        end
    end

end