module Resource::Nested::SetResource
    
    private
    
        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_resource
            @resource_route = params[:parent_resource] ? params[:parent_resource] : controller_name
            klass = @resource_route.singularize.capitalize.constantize
            @resource = params[:parent_resource_id] ? klass.find(params[:parent_resource_id]) : klass.new
        end
end