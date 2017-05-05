module Modules::RoleFormFields
    def role_fields(resource, target_resource = nil)
        target_resource ||= resource.class.new

        collection_check_boxes(resource.class.name.downcase, 
                                :role_ids, 
                                target_resource.roles, 
                                :id, 
                                :name) do |field|
            content_tag :div, field.label { field.check_box + field.text }, class: 'checkbox'
        end

    end
end