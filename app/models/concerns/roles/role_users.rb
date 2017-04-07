module Roles::RoleUsers
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        Roles::Helper.invoke(source)
        define_class_methods(source)

        source.class_eval do
          after_initialize :build_all_role_methods
        end
    end

    # Fetch all roles available to the object's class, iterate through each and then dynamically define a class method for said role
    def build_all_role_methods(source = self.class)
        source.find_roles.distinct.pluck(:name).map { |role| source.create_role_method(role) }
    end

    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    def define_class_methods(source = self)
        # Dynamically defines methods to fetch users of a specific role
        def source.create_role_method(role, object = self)
            object.send(:define_method, role.to_s.pluralize) do
                role_user = "@#{role}_users"

                if instance_variable_defined?(role_user)
                    instance_variable_get(role_user)
                else
                    role_object = self.roles.find_by_name(role)
                    instance_variable_set(role_user, role_object ? role_object.users : nil)
                end
            end
        end
    end

    extend self
end