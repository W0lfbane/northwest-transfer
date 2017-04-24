module Concerns::Resource::Nested::SetResource

    private

        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_resource
            route_array = request.fullpath.split('/')
            resource_route = route_array[1]
            klass = resource_route.singularize.capitalize.constantize
            object_id = route_array[2]
            @resource = object_id ? klass.find(object_id) : klass.new
        end

end
