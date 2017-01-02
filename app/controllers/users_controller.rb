class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
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

end