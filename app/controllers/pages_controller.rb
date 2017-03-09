class PagesController < ApplicationController
    include Concerns::String::SqlFilters
    
    before_action :authorize_page

    def show
        params[:resources].each do |key, value|
            value_to_set = destructive_transaction?(value) ? nil : eval(value)
            instance_variable_set( "@#{key}", policy_scope(value_to_set) ) unless value_to_set.nil?
        end unless(params[:resources].nil?)

        render template: "pages/#{params[:page]}"
    end
    
    private

        def authorize_page
            authorize :page
        end
end