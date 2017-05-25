class TasksController < ApplicationController
  include Concerns::Notes::Nested::SetAuthor
  include Concerns::Resource::Nested::SetParentResource
  include Concerns::Resource::State::ResourceStateChange

  before_action :authenticate_user!
  before_action :set_parent_resource
  before_action :set_task, except: [:index, :create]
  before_action :authorize_task, except: [:index, :create]
  before_action :set_author, only: [:create, :update]

  # GET /tasks
  # GET /tasks.json
  def index
    @parent_resource.class == Task ? @tasks = policy_scope(Task) : @tasks = policy_scope(@parent_resource.tasks)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @parent_resource.class == Task ? @parent_resource : @parent_resource.tasks.build(task_params)
    authorize_task

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_path(id: @task), notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: task_path(id: @task) }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_path(id: @task), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: task_path(id: @task) }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to @parent_resource, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_task
      if @parent_resource.class == Task
        @task = @parent_resource
      else
        @task = params[:id] ? @parent_resource.tasks.find(params[:id]) : @parent_resource.tasks.build
      end
    end

    def authorize_task
      authorize @task
    end

    def task_params
      params.require(:task).permit(:name,
                                    :description,
                                    :resource_state,
                                    notes_attributes: [:text, :user_id, :_destroy])
    end

end
