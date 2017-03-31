module Concerns::Notes::Nested::SetAuthor
  
  private
  
    # This method is used to find the note or note_attributes node and update the author to current_user
    def set_author
      model = controller_name.singularize.downcase
      if model == "note"
        params[model][:user_id] = current_user.id
      elsif params[model].key? :notes_attributes
        params[model][:notes_attributes].each do |note|
          params[model][:notes_attributes][note][:user_id] = current_user.id
        end
      end
    end
end