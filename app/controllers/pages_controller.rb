class PagesController < ApplicationController
    def show
        authorize :page
        params[:resources].each { |key, value| instance_variable_set("@#{key}", eval(value)) } unless params[:resources].nil?
        render template: "pages/#{params[:page]}"
    end
end