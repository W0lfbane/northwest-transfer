module Concerns::Resource::Role::ResourceRoleChange
  
  # Takes a parameter list of roles to be added to the resource
  def resource_role_change
    model = controller_name.singularize.capitalize.constantize
    id = params[:id] || params["#{controller_name.singularize}_id"]
    resource ||= model.send(:find, id)
    roles = (params[:roles] || params[controller_name.singularize][:role_ids]).map { |role_id| Role.find(role_id) if role_id.present? }.compact
    resource_roles = resource.roles

    begin
      roles.map { |role| resource_roles.include?(role) ? next : resource.add_role(role.name, role.find_resource) }
      
      # Allow the controller to optionally set the target resource with @resource
      target_resource = @resource || resource
      inverse_roles = target_resource.roles - roles
      inverse_roles.map { |role| resource.remove_role(role.name, role.find_resource) }
    rescue => e
      logger.error(e.message)
      redirect_to target_resource, flash: { error: "The role could not be updated!" }
    else
      redirect_to target_resource, flash: { success: "Role updated successfully!" }
    end
  end

end