class Flexible::ResourceController < ResourceController
  include Concerns::Resource::Nested::SetParentResource

  before_action :set_parent_resource

  def index
    set_resource_variable(@parent_resource.class == resource_class ? 
                                      policy_scope(resource_class) : 
                                      policy_scope(@parent_resource.send(resource_name.pluralize)),
                          "@#{resource_name.pluralize}")
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

  private

    def resource_path
      "#{resource_name}_path".to_sym
    end

    def set_resource
      if @parent_resource.class == resource_class
        set_resource_variable(@parent_resource)
      else
        set_resource_variable(params[:id] ? @parent_resource.send(resource_name.pluralize).find(params[:id]) : @parent_resource.send(resource_name.pluralize).build)
      end
    end
    
end
