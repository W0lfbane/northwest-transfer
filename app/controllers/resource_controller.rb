class ResourceController < ApplicationController
  respond_to :html, :json

  before_action :set_resource, except: [:index, :create]
  before_action :authorize_resource, except: [:index, :create]

  def index
    set_resource_variable(policy_scope(resource_class), "@#{resource_name.pluralize}") 
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    set_resource_variable(resource_class.create(resource_params))
    authorize_resource
    respond_with resource
  end

  def update
    resource.update(resource_params)
    respond_with resource
  end

  def destroy
    resource.destroy
    respond_to do |format|
      format.html { redirect_to @parent_resource, notice: "#{resource_class.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    
    def resource_name
      controller_name.singularize
    end

    def resource_class
      resource_name.titleize.constantize
    end

    def resource_params
      self.send("#{resource_name}_params")
    end
    
    def set_resource_variable(value, name = "@#{resource_name}")
      instance_variable_set(name, value)
    end

    def set_resource
        set_resource_variable(params[:id] ? resource_class.find(params[:id]) : resource_class.new)
    end
    
    def resource
      instance_variable_get("@#{resource_name}")
    end

    def authorize_resource
      authorize resource
    end

end
