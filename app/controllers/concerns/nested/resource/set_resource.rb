module Nested::Resource::SetResource
    
    private
    
        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_resource
            route_array = request.fullpath.split('/')
            p route_array
            @route_resource = params["resource"]
            klass = @route_resource.singularize.capitalize.constantize
            object_id = params["resource_id"]
            @resource = klass.find(object_id)
        end
end