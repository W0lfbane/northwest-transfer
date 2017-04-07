class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :create]
  before_action :authorize_group, except: [:index, :create]

  def index
    @groups = policy_scope(Group).page(params[:page])
  end

  def user_groups_index
    @groups = policy_scope( current_user.groups ).page(params[:page]).order(:created_at)
    render :index
  end

  def show
  end

  def new
  end

  def create
    @group = Group.new(group_params)
    authorize_group
    if @group.save
      redirect_to @group, flash: { success: "Group successfully updated!" }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update_attributes(group_params)
      redirect_to @group, flash: { success: "Group successfully updated!" }
    else
      render :edit
    end
  end

  def destroy
    @group.deactivate!(current_user)
    redirect_to groups_path, flash: { success: "Group successfully deactivated!" }
  end

  private

    def set_group
      @group = params[:id] ? Group.find(params[:id]) : Group.new
    end

    def authorize_group
      authorize @group
    end

    def group_params
      params.require(:group).permit(:name, :description)
    end

end
