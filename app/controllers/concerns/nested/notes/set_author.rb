module Nested::Notes::SetAuthor
    
    private
    
        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_resource
            params[:note][:author] = current_user unless params[:note].nil?
        end
end