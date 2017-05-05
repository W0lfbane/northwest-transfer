module Modules::RoleFormFields
    def role_fields(f, resource, target_resource = nil)
        target_resource ||= resource.class.new

        f.collection_check_boxes(:role_ids, 
                                resource.find_roles(target_resource.persisted? ? target_resource.class.name : nil, target_resource.id), 
                                :id, 
                                :name) do |field|
            content_tag :div, field.label { field.check_box + field.text }, class: 'checkbox'
        end

    end
end