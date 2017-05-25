class Flexible::ApplicationController < ApplicationController
  include Concerns::Resource::Nested::SetParentResource
  respond_to :html, :json

  before_action :set_parent_resource
  before_action :set_resource, except: [:index, :create]
  before_action :authorize_resource, except: [:index, :create]

  def index
    set_resource_variable("@#{resource_name.pluralize}", 
                            @parent_resource.class == resource_class ? 
                                        policy_scope(resource_class) : 
                                        policy_scope(@parent_resource.send(resource_name.pluralize)))
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    set_resource_variable(@parent_resource.class == resource_class ? 
                                                  @parent_resource : 
                                                  @parent_resource.send(resource_name.pluralize).create(resource_params))

    authorize_resource
    respond_with resource, location: helpers.flexible_resource_path(resource_path, resource)
  end

  def update
    resource.update(resource_params)
    respond_with resource, location: helpers.flexible_resource_path(resource_path, resource)
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
    
    def resource_path
      "#{resource_name}_path".to_sym
    end
    
    def resource_params
      self.send("#{resource_name}_params")
    end
    
    def set_resource_variable(name = "@#{resource_name}", value)
      instance_variable_set(name, value)
    end

    def set_resource
      if @parent_resource.class == resource_class
        set_resource_variable(@parent_resource)
      else
        set_resource_variable(params[:id] ? @parent_resource.send(resource_name.pluralize).find(params[:id]) : @parent_resource.send(resource_name.pluralize).build)
      end
    end
    
    def resource
      instance_variable_get("@#{resource_name}")
    end

    def authorize_resource
      authorize resource
    end

end
