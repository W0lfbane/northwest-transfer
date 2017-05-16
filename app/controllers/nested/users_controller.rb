class Nested::UsersController < UsersController
  include Concerns::Resource::Nested::SetResource

  prepend_before_action :set_resource

  def edit
  end

  def destroy
    @resource.users.destroy(@user)
    redirect_to @resource, flash: { success: "User successfully removed!" }
  end

  protected
  
    def set_user
      if @resource.class == User
        @user = @resource
      else
        @user = params[:id] ? @resource.users.find(params[:id]) : @resource.users.build
      end
    end

end
