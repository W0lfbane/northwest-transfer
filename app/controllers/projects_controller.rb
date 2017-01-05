class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update]
  before_action :authorize_project, except: :index

  def index
    @projects = policy_scope(Project)
  end

  def show
  end

  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, success: "Project successfully updated!"
    else
      render :new
    end
  end

  def edit
    @step = params[:step] unless params[:step].nil?
    redirect_to 'root_path' unless @project.interacting_with_state?(@step)
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to @project, success: "Project successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.deactivate!
    redirect_to projects_path, success: "Project successfully deactivated!"
  end
  
  private
    
    def set_project
      @project = Project.find(params[:id])
    end
    
    def authorize_project
      authorize @project
    end
  
    def project_params
      params.require(:project).permit(:title, 
                                      :description, 
                                      :location, 
                                      :start_date, 
                                      :completion_date, 
                                      :estimated_time, 
                                      :total_time, 
                                      :notes,
                                      document_attributes: [:id, :title])
    end

end
