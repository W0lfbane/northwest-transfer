class Nested::Users::RegistrationsController < Users::RegistrationsController
  include Concerns::Resource::Nested::SetResource

  prepend_before_action :set_resource

  def edit
  end

  def destroy
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
