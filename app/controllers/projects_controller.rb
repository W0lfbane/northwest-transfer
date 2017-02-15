class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:index, :create]
  before_action :authorize_project, except: [:index, :create]

  def index
    if request.original_url.include?( schedule_path )
      @projects = policy_scope( current_user.projects.where("DATE(start_date) = ?", Date.today).order(:start_date).page(params[:page]) )
    elsif request.original_url.include?( user_projects_path )
      @projects = policy_scope( current_user.projects.order(:start_date).page(params[:page]) )
    else
      @projects = policy_scope( Project.order(:start_date).page(params[:page]) )
    end
  end

  def show
  end

  def new
  end

  def create
    @project = Project.new(project_params)
    authorize_project
    if @project.save
      redirect_to @project, success: "Project successfully updated!"
    else
      render :new
    end
  end

  def edit
    unless current_user.admin?
      @step = params[:step].to_sym unless params[:step].nil?
      redirect_to root_path unless @project.interacting_with_state?(@step)
    end
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to @project, success: "Project successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @project.deactivate!
    redirect_to projects_path, success: "Project successfully deactivated!"
  end
  
  private
    
    def set_project
      @project = params[:id] ? Project.find(params[:id]) : Project.new
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
                                      :notes,
                                      document_attributes: [:id, :title, :_destroy],
                                      tasks_attributes: [:id, :name, :description, :_destroy])
    end

end
