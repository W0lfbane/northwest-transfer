class Nested::UsersController < UsersController
  include Concerns::Resource::Nested::SetParentResource

  skip_before_action :require_no_authentication
  prepend_before_action :authenticate_scope!
  prepend_before_action :set_parent_resource
  before_action :set_users, only: [:new, :create]

  def index
    @users = @parent_resource.users
  end

  def new
  end
  
  def create
    @user = user_params[:id].present? ? User.find(user_params[:id]) : @parent_resource.users.build
    if @user.persisted? && !@parent_resource.users.include?(@user) && @parent_resource.users << @user
      redirect_to @parent_resource, flash: { success: "User successfully added!" }
    else
      case
        when @user.new_record?
          @user.errors.add(:user, 'must be present!')
        when @parent_resource.users.include?(@user)
          @user.errors.add(:user, 'is already added!')
        else
          @user.errors.add(:user, 'could not be added due to an unknown problem.')
      end

      render :new
    end
  end

  def edit
  end

  def destroy
    @parent_resource.users.destroy(@user)
    redirect_to @parent_resource, flash: { success: "User successfully removed!" }
  end

  protected
  
    def set_user
      if @parent_resource.class == User
        @user = @parent_resource
      else
        @user = params[:id].present? ? @parent_resource.users.find(params[:id]) : @parent_resource.users.build
      end
    end

    def set_users
      @users = (User.all - @parent_resource.users)
    end

    def user_params
      params.require(:user).permit(:id, {:role_ids => []})
    end

end
