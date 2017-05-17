module Concerns::Resource::Role::ResourceRoleChange
  
  # Takes a parameter list of roles to be added to the resource
  def resource_role_change
    model = controller_name.singularize.capitalize.constantize
    id = params[:id] || params["#{controller_name.singularize}_id"]
    resource = model.send(:find, id)

    # Allow the controller to optionally set the target resource with @resource
    target_resource = @resource || resource

    roles = (params[:roles] || params[controller_name.singularize][:role_ids]).map { |role_id| Role.find(role_id) if role_id.present? }.compact

    if resource.change_roles(roles, target_resource.roles)
      redirect_to target_resource, flash: { success: "Role updated successfully!" }
    else
      redirect_to target_resource, flash: { error: "The role could not be updated!" }
    end
  end

end