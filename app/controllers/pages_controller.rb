class PagesController < ApplicationController
    def show
        authorize :page
        params[:resources].each { |key, value| instance_variable_set("@#{key}", is_invalid?(value) ? nil : eval(value)) } unless params[:resources].nil?
        render template: "pages/#{params[:page]}"
    end
    
private
    #returns true if input string does not follow pattern of: Modelname or Modelname.find/where/order/limit
    #note: the where query is currently limited to only very simple, single conditions
    def is_invalid? (value)
        value !~ /(?:\A[A-Z][a-z]+)(?:(\.)?(?(1)(?:(?:limit|where|find|order)\(\w+:?\s?\w*\))))*$/
    end
end