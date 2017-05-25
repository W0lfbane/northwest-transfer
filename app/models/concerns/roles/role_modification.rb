module Concerns::Roles::RoleModification
  
  # Takes a parameter list of roles to be added to the resource
  def change_roles(roles, roles_to_remove = nil, resource = self)
    add_roles(roles, resource)
    remove_roles(roles_to_remove, resource) if roles_to_remove.present?
    
    return resource.roles
  end
  
  def add_roles(roles, resource = self)
    roles.map { |role| resource.roles.include?(role) ? next : resource.add_role(role.name, role.polymorphic_resource) }

    rescue => e
      logger.error(e.message)
  end
  
  def remove_roles(roles, resource = self)
    roles.map { |role| resource.remove_role(role.name, role.polymorphic_resource) }

    rescue => e
      logger.error(e.message)
  end

end