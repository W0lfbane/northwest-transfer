module Concerns::Resource::State::ResourceStateChange

  # Takes a parameter STATUS_METHOD, which is the name of the role method to be invoked.
  def resource_state_change
    model = controller_name.singularize.capitalize.constantize
    @resource = model.send(:find, params[:id])

    begin
      @resource.send(params[:status_method] + '!')
    rescue => e
      logger.error(e.message)
      redirect_to @resource, flash: { error: "The status could not be updated!" }
    else
      redirect_to @resource, flash: { success: "Status updated successfully!" }
    end
  end

end
