module Roles::RoleUsers
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        define_class_methods(source)

        source.class_eval do
          after_initialize :build_all_role_methods
          after_initialize :define_instance_methods
        end
    end

    # Fetch all roles available to the object's class, iterate through each and then dynamically define a class method for said role
    def build_all_role_methods(source = self.class)
        source.show_roles.map { |role| source.create_role_method(role) }
    end

    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    def define_class_methods(source = self)
        # Dynamically defines methods to fetch users of a specific role
        def source.create_role_method(role, object = self)
            object.send(:define_method, role.to_s.pluralize) do
                role_user = "@#{role}_users"
                puts self.roles
    
                # Fix this query, N+1 problem
                instance_variable_defined?(role_user) ? instance_variable_get(role_user) : 
                                                    instance_variable_set( role_user, self.roles.find(name: role).users )
            end
        end
    
        define_instance_methods(source)
    end

    def define_instance_methods(source = self)
        # Returns an array of strings that are existing roles on an object
        def source.show_roles(object = self)
            if object.respond_to?(:roles)
                @roles ||= object.roles.distinct.pluck(:name)
            elsif object.respond_to?(:find_roles)
                @roles ||= object.find_roles.distinct.pluck(:name)
            else
                false
            end
        end
    end


    extend self
end