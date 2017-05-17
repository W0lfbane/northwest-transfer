class Nested::UsersController < UsersController
  include Concerns::Resource::Nested::SetResource

  skip_before_action :require_no_authentication
  prepend_before_action :authenticate_scope!
  prepend_before_action :set_resource
  before_action :set_users, only: [:new, :create]

  def index
    @users = @resource.users
  end

  def new
  end
  
  def create
    @user = user_params[:id].present? ? User.find(user_params[:id]) : @resource.users.build
    if @user.persisted? && !@resource.users.include?(@user) && @resource.users << @user
      redirect_to @resource, flash: { success: "User successfully added!" }
    else
      case
        when @user.new_record?
          @user.errors.add(:user, 'must be present!')
        when @resource.users.include?(@user)
          @user.errors.add(:user, 'is already added!')
      end

      render :new
    end
  end

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
        @user = params[:id].present? ? @resource.users.find(params[:id]) : @resource.users.build
      end
    end

    def set_users
      @users = (User.all - @resource.users)
    end

    def user_params
      params.require(:user).permit(:id, {:role_ids => []})
    end

end
