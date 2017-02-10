class CalendarController < ApplicationController
  before_action :authenticate_user!
  

  def index
    params[:resources].each { |name, resource|
      authorize resource
      instance_variable_set("@#{name}", policy_scope(resource)) 
    } unless params[:resources].nil?

    render template: "calendar/#{params[:page]}"
  end
  
end
