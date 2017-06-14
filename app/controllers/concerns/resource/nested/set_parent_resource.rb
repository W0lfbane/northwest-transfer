module Concerns::Resource::Nested::SetParentResource

    private

        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_parent_resource
            route_array = request.fullpath.split('/')
            resource_route = route_array[1]
            klass_name = resource_route.singularize.capitalize
            klass = defined?(klass_name.constantize) ? klass_name.constantize : controller_name.singularize.capitalize.constantize
            object_id = route_array[2]
            @parent_resource = (object_id.present? && object_id.to_i > 0) ? klass.find(object_id) : klass.new
        end
end
