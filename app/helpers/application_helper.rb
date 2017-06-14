module ApplicationHelper
    include Modules::ExtendableNestedFormFields
    include Modules::BootstrapFlashMessages

    # Usage: <% title(STRING or method that returns STRING) %>
    def title(page_title)
        content_for :title, page_title.to_s unless @title_method_called
        @title_method_called = true
    end

    # Usage: flexible_resource_path(SYMBOL OR STRING, OBJECT), returns the correct path name based on URL scheme
    def flexible_resource_path(route, resource = controller_name.singularize.titleize.constantize.new)
        resource_klass = resource.class.name.downcase
        nested_route_klass_index = route.to_s.index(resource_klass)
        nested_route = route.to_s.insert(nested_route_klass_index, "nested_") unless (nested_route_klass_index.nil? || Rails.application.routes.recognize_path(request.fullpath)[:controller] == resource_klass.pluralize)
        # Allow controllers to optionally set @resource
        found_resource = @resource || resource.polymorphic_resource if nested_route.present?
        
        nested_route.nil? ? self.send(route, resource) : self.send(nested_route, 
                                                                    found_resource.present? ? found_resource.class.name.downcase.pluralize : controller_name,
                                                                    found_resource || params[:id], id: resource.id)
    end

    # Returns a formatted DateTime
    def format_date_with_time(datetime)
        datetime.strftime("%m/%d/%Y at %I:%M%p")
    end

    # Returns an internationalized key => value paired collection of states defined on the model
    def resource_states(klass)
       states = klass::STATES.clone
       parsed_states = states.map { |n| I18n.t(n).capitalize }
       paired_state_hash = Hash[parsed_states.zip(states)]

       return paired_state_hash
    end

end