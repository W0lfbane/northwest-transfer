require 'rails_helper'

RSpec.describe "Edit Project Route", :type => :request do
    describe "Edit project step path for projects#edit" do
        context "logged in as admin" do
          before :each do
              @admin = FactoryGirl.create(:admin)
              @project = FactoryGirl.create(:project)
              sign_in(@admin)
              @admin.add_role :leader, @project
              @admin.projects << @project
          end
            
          it "get the project edit page by the project id and pending" do
              get edit_project_step_path(@project)
              expect(response).to have_http_status(:success)
          end
          
          it "redirects if wrong step is passed in" do
              get edit_project_step_path(@project, step: :completed) 
              expect(response).to have_http_status(:redirect)
          end
          
          it "renders show template" do
              get edit_project_step_path(@project)
              expect(response).to render_template :edit
          end
        end
        
        context "logged in as user" do
          before :each do
              @user = FactoryGirl.create(:user)
              @project = FactoryGirl.create(:project)
              sign_in(@user)
              @user.add_role :leader, @project
              @user.projects << @project
          end
            
          it "get the project edit page by the project id and pending" do
              get edit_project_step_path(@project)
              expect(response).to have_http_status(:success)
          end
          
          it "redirects if wrong step is passed in" do
              get edit_project_step_path(@project, step: :completed) 
              expect(response).to have_http_status(:redirect)
          end
          
          it "renders show template" do
              get edit_project_step_path(@project)
              expect(response).to render_template :edit
          end
        end
    end
end