module Concerns::Notes::Nested::SetAuthor
  
  private
  
    # This method is used to find the note or note_attributes node and update the author to current_user
    def set_author
      model = controller_name.singularize.downcase
      if model == "note"
        params[model][:author] = current_user.name
      elsif params[model].key? :notes_attributes
        params[model][:notes_attributes].each do |note|
          params[model][:notes_attributes][note][:author] = current_user.name
          puts params[model][:notes_attributes][note][:author]
        end
      end
    end
end