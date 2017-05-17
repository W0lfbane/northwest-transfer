module RolesHelper
    # Usage: <%= role_fields(form object, collection of ROLE objects) %>, returns buttons mapping to the correct URL to change the role of a resource
    def role_fields(f, collection)
        f.collection_check_boxes(:role_ids, collection, :id, :name) do |field|
            content_tag :div, field.label { field.check_box + field.text }, class: 'checkbox'
        end
    end
end
