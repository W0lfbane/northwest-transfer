module Helpers::ResourceRolesHelper
    # Ghost Method technique for dynamism in role entries
    def method_missing(method, *args)
        method_name = method.to_s
        role_name = method_name.singularize
        method_is_role = method_name[/[a-zA-Z]+/] == method_name

        if( show_roles(self.class).include?(role_name) && method_is_role )
            role_user = "@#{role_name}_users"

            instance_variable_get(role_user) ? instance_variable_get(role_user) : instance_variable_set(role_user, User.with_role(role_name, self))
        else
            super
        end
    end
    
    #allows objects that implement above ghost method to return true for #respond_to and #method for generated methods
    def respond_to_missing?(method, *)
      method_name = method.to_s
      role_name = method_name.singularize
      method_is_role = method_name[/[a-zA-Z]+/] == method_name 
      if (self.respond_to?(:roles) && self.class.respond_to?(:find_roles))
        show_roles(self.class).include?(role_name) && method_is_role
      else 
        super
      end
    end

    # Returns and array of existing roles on self
    def show_roles(object = self)
        if object.respond_to?(:roles)
            @roles ||= object.roles.pluck(:name)
        else
            @roles ||= object.find_roles.pluck(:name)
        end
    end
    


end