class PagesController < ApplicationController
    def show
        authorize :page
        params[:resources].each { |name, value| instance_variable_set("@#{name}", value) } unless params[:resources].nil?
        render template: "pages/#{params[:page]}"
    end
end