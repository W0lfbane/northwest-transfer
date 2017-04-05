class ProjectsController < ApplicationController
  include Concerns::Notes::Nested::SetAuthor
  include Concerns::Resource::State::ResourceStateChange
  
  before_action :authenticate_user!
  before_action :set_project, except: [:index, :create]
  before_action :authorize_project, except: [:index, :create]
  before_action :set_author, only: [:create, :update]
  before_action :set_form_resources, only: [:new, :edit, :update, :create]

  def index
    @projects = policy_scope( Project ).order(:start_date).page(params[:page])
  end

  def user_projects_index
    @projects = policy_scope( current_user.projects ).order(:start_date).page(params[:page])
    render :index
  end

  def schedule_index
    @projects = policy_scope( current_user.projects.where("DATE(start_date) = ?", Date.today) ).order(:start_date).page(params[:page])
    render :index
  end

  def show
  end

  def new
  end

  def create
    @project = Project.new(project_params)
    authorize_project
    if @project.save
      redirect_to @project, flash: { success: "Project successfully created!" }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to @project, flash: { success: "Project successfully updated!" }
    else
      render :edit
    end
  end

  def destroy
    @project.deactivate! current_user
    redirect_to projects_path, flash: { success: "Project successfully deactivated!" }
  end
  
  private
    
    def set_project
      @project = params[:id] ? Project.find(params[:id]) : Project.new
    end
    
    def set_form_resources
      @users = User.all
    end
    
    def authorize_project
      authorize @project
    end
  
    def project_params
      params.require(:project).permit(:title, 
                                      :description, 
                                      :address,
                                      :city,
                                      :state,
                                      :postal,
                                      :country,
                                      :start_date, 
                                      :completion_date, 
                                      :estimated_completion_date, 
                                      :total_time, 
                                      :resource_state,
                                      notes_attributes: [:id, :text, :user_id, :_destroy],
                                      document_attributes: [:id, :title, :resource_state, :signature, :completion_date, :_destroy],
                                      tasks_attributes: [:id, :name, :description, :resource_state, :_destroy],
                                      users_attributes: [:id, :_destroy])
    end

end
