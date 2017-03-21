module Concerns::Nested::Notes::SetAuthor
    
    private
    
        # This method is used to infer an object's class and it's ID by using common patterns among routes
        def set_author
            params.each do |key, value|
              if params[key].class == ActionController::Parameters
                if params[key].key? :notes_attributes
                  params[key][:notes_attributes].each do |note|
                    params[key][:notes_attributes][note][:author] = current_user.name
                    puts params[key][:notes_attributes][note][:author]
                  end 
                elsif params[key].key? :author
                  params[key][:author] = current_user.name
                end
              end 
            end
        end
end