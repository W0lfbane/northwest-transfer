class PagesController < ApplicationController
    def show
        params[:resources].each { |name, value| instance_variable_set("@#{name}", value) } unless params[:resources].nil?
        render template: "pages/#{params[:page]}"
    end
end