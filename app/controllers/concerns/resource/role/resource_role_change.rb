module Resource::Role::ResourceRoleChange
  
  # Takes a parameter, which is the name of the role method to be invoked. 
  def resource_role_change
    model = controller_name.singularize.capitalize.constantize
    id = params[:id] || params["#{controller_name.singularize}_id"]
    @resource ||= model.send(:find, id)
    roles = params[:roles].nil? ? [] : params[:roles].map(&:to_sym)

    begin
      roles.each do |role_name|
        role = Role.find_by_name(role_name)
        if @resource.roles.include? role
          next
        else
          @resource.roles << role
        end
      end

      inverse_role_names = @resource.class::ROLES - roles
      inverse_role_list = inverse_role_names.map { |role_name| Role.find_by_name(role_name) }
      @resource.roles -= inverse_role_list
    rescue => e
      logger.error(e.message)
      redirect_to @resource, flash: { error: "The role could not be updated!" }
    else
      redirect_to @resource, flash: { success: "Role updated successfully!" }
    end
  end

end