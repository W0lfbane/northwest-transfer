class RolesController < ApplicationController
  include Resource::Nested::SetResource

  before_action :authenticate_user!
  before_action :set_resource
  before_action :set_role, except: [:index, :create]
  before_action :authorize_role, except: [:index, :create]

  # GET /roles
  # GET /roles.json
  def index
    @roles = policy_scope(@resource.roles)
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = @resource.roles.build(role_params)
    authorize_role

    respond_to do |format|
      if @role.save
        format.html { redirect_to role_path(@resource_route, @resource, @role), notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: role_path(@resource_route, @resource, @role) }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to role_path(@resource_route, @resource, @role), notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: role_path(@resource_route, @resource, @role) }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url(@resource_route, @resource), notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_role
      @role = params[:id] ? @resource.roles.find(params[:id]) : @resource.roles.build
    end
    
    def authorize_role
      authorize @role
    end

    def role_params
      params.require(:role).permit(:name, :resource_type, :resource_id)
    end

end