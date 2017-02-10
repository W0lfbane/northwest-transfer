class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :create]
  before_action :authorize_group, except: [:index, :create]

  def index
    if request.original_url.include?( user_groups_path )
      @groups = policy_scope( current_user.groups )
    else
      @groups = policy_scope(Group)
    end
  end

  def show
  end

  def new
  end
  
  def create
    @group = Group.new(group_params)
    authorize_group
    if @group.save
      redirect_to @group, success: "Group successfully updated!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update_attributes(group_params)
      redirect_to @group, success: "Group successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @group.deactivate!
    redirect_to groups_path, success: "Group successfully deactivated!"
  end
  
  private
    
    def set_group
      @group = params[:id] ? Group.find(params[:id]) : Group.new
    end
    
    def authorize_group
      authorize @group
    end
  
    def group_params
      params.require(:group).permit(:title, :description)
    end

end
