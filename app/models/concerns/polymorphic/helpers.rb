module Concerns::Polymorphic::Helpers
    def resourcable_type_name(object = self)
        object.attributes.keys.keep_if { |attribute| attribute.include?('_type') }.first
    end

    def resourcable_id_name(object = self)
        resourcable_type_name.sub('_type', '_id')
    end

    def find_resource(object = self)
        resource = object.send(resourcable_type_name)
        id = object.send(resourcable_id_name)
        @resource ||= resource.singularize.classify.constantize.find(id) if (id && resource).present?
    end

    def find_resources(object = self)
        @resources = Array.new

        if object.respond_to? :each
            object.each do |item|
                @resources << find_resource(item)
            end
        else
            @resources << find_resource
        end
    end

    def remove_resource_association(object = self)
        object[resourcable_type_name] = nil
        object[resourcable_id_name] = nil
        object.save!
    end

end
