class ProjectsController < ApplicationController
  include Notes::Nested::SetAuthor
  include Resource::State::ResourceStateChange
  
  before_action :authenticate_user!
  before_action :set_project, except: [:index, :create]
  before_action :authorize_project, except: [:index, :create]
  before_action :set_author, only: [:create, :update]
  before_action :build_document, only: [:new, :edit]

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
      redirect_to @project, flash: { success: "Project successfully updated!" }
    else
      render :new
    end
  end

  def edit
    # This is unfinished. If a test is implemented on it, use the following intentions:
    # An admin does not need to provide a step, and instead will be presented with the full projects#edit template if no step is passed
    # An admin can optionally pass a step to see the same view as a regular user (admins should ALWAYS have access to the same views/information that non-privileged users do)
    # Unless the user is an admin, it should collect a step from the route.
    # If no step is present, or an invalid step is passed, it will gather the project's current state using the AASM helper (do not use resource state)
    # Information provided to the template will vary based upon the step, with all information present from previously completely steps
    @step = params[:step]
    
    unless current_user.admin?
      redirect_to edit_project_step_path(@project, step: @project.aasm.current_state) unless @project.interacting_with_state?(@step)
    end
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to @project, flash: { success: "Project successfully updated!" }
    else
      render :edit
    end
  end

  def destroy
    @project.deactivate!
    redirect_to projects_path, flash: { success: "Project successfully deactivated!" }
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
                                      :resource_state,
                                      notes_attributes: [:id, :text, :author, :_destroy],
                                      document_attributes: [:id, :title, :_destroy],
                                      tasks_attributes: [:id, :name, :description, :resource_state, :_destroy])
    end
    
    def build_document
      @project.build_document if @project.document.nil?
    end


end
