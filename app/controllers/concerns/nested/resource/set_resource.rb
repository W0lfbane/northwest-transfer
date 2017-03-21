module Concerns::Nested::Resource::SetResource
    
    private
    
        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_resource
            route_array = request.fullpath.split('/')
            @route_resource = route_array[1]
            klass = @route_resource.singularize.capitalize.constantize
            object_id = route_array[2]
            @resource = klass.find(object_id)
        end
end