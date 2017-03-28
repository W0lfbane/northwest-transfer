class UsersController < ApplicationController
  include Resource::Role::ResourceRoleChange

  before_action :authenticate_user!
  before_action :set_user, except: :index
  before_action :authorize_user, except: :index

  def index
    authorize User
    @users = policy_scope(User)
  end

  def show
  end

  private
    
    def set_user
      user_id = params[:id]
      @user = user_id ? User.find(user_id) : current_user
    end
    
    def authorize_user
      authorize @user
    end
    
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone)
    end

end