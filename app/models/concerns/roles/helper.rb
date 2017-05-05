module Roles::Helper
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def invoke(source)
        define_class_methods(source)
        define_instance_methods(source)
    end

    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    def define_class_methods(source = self)
        class << source
            # Returns an array of strings that are existing roles on an object
            def role_names(object = self)
                if object.respond_to?(:roles)
                    @roles ||= object.roles.distinct.pluck(:name).uniq
                elsif object.respond_to?(:find_roles)
                    @roles ||= object.find_roles.distinct.pluck(:name).uniq
                elsif object::ROLES.present?
                    @roles ||= object::ROLES
                end
            end
        end
    end

    def define_instance_methods(source = self)
        source.class_eval do
            # Returns an array of strings that are existing roles on an object
            def role_names
                @roles ||= self.roles.distinct.pluck(:name).uniq if self.respond_to?(:roles)
            end
            
            def find_roles(resource_type, resource_id)
                self.roles.where(resource_type: resource_type, resource_id: resource_id)
            end
        end
    end
    
    extend self
end