class PagesController < ApplicationController
    include Concerns::String::SqlFilters
    
    before_action :authorize_page

    def show
        params[:resources].each do |name, resource|
            evaluated_resource = safe_transaction?(value) ? policy_scope(eval(value)) : nil 
            instance_variable_set("@#{name}", evaluated_resource)
        end unless(params[:resources].nil?)

        render template: "pages/#{params[:page]}"
    end
    
    private

        def authorize_page
            authorize :page
        end

end