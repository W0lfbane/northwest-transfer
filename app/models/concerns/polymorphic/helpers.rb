module Concerns::Polymorphic::Helpers

    def resourcable_type_name(object = self)
        object.attributes.keys.keep_if { |attribute| attribute.include?('_type') }.first
    end

    def resourcable_id_name(object = self)
        resourcable_type_name.sub('_type', '_id')
    end

    def polymorphic_resource(object = self)
        klass = object.send(resourcable_type_name)
        id = object.send(resourcable_id_name)
        klass.singularize.classify.constantize.find(id) if (id && klass).present?
    end

    def polymorphic_resources(object = self)
        if object.respond_to?(:map)
            object.map { |item| polymorphic_resource(item) }
        else
            polymorphic_resource
        end
    end

    def remove_resource_association(object = self)
        object[resourcable_type_name] = nil
        object[resourcable_id_name] = nil
        object.save!
    end

end
