require 'rails_helper'

RSpec.describe "Projects Calendar Route", :type => :request do
   describe "path for projects#calendar" do
        before :each do
          @user = FactoryGirl.create(:user)
          @project = FactoryGirl.create(:project, start_date: Date.today)
          sign_in(@user)
        end
        
        it "Displaying the calendar" do
          get projects_calendar_path,  params: { projects: Project.all }
          expect(response).to have_http_status(:success)
        end
        
        it "set the projects to nil" do
          get projects_calendar_path,  params: { projects: nil }
          expect(response).to have_http_status(:success)
        end
        
        it "Pass with no params" do
          get projects_calendar_path
          expect(response).to have_http_status(:success)
        end
  end
end