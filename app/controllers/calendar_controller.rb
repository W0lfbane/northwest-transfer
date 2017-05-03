class CalendarController < ApplicationController
  include Concerns::SQL::SqlFilters

  before_action :authenticate_user!
  
  # In the case of destructive transactions
  skip_after_action :verify_policy_scoped, only: :index

  def index
    params[:resources].each do |name, resource|
      if safe_transaction?(resource)
        evaluated_resource = eval(resource)
        authorize evaluated_resource
        instance_variable_set("@#{name}", policy_scope(evaluated_resource))
      else
        instance_variable_set("@#{name}", nil)
      end
    end unless params[:resources].nil?
  end
  
end
