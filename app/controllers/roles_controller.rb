class RolesController < Flexible::ApplicationController

  before_action :authenticate_user!

  private

    def role_params
      params.require(:role).permit(:name, :resource_type, :resource_id)
    end

end