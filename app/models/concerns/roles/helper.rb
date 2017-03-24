module Roles::Helper
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def invoke(source)
        define_class_methods(source)

        source.class_eval do
          after_initialize :define_instance_methods
        end
    end

    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    def define_class_methods(source = self)
        define_instance_methods(source)
    end

    def define_instance_methods(source = self)
        # Returns an array of strings that are existing roles on an object
        def source.role_names(object = self)
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