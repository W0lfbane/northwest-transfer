module Resource::Nested::SetResource
    
    private
    
        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_resource
            @resource_route = params[:resource] ? params[:resource] : controller_name
            klass = @resource_route.singularize.capitalize.constantize
            @resource = params[:resource_id] ? klass.find(params[:resource_id]) : klass.new
        end
end