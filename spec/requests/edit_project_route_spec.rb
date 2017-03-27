require 'rails_helper'

RSpec.describe "Edit Project Route", :type => :request do

    shared_examples_for "valid id and step" do
      it "gets the project edit page by the project id and step" do
          get edit_project_step_path(@project, step: @project.aasm.current_state)
          expect(response).to have_http_status(:success)
      end
    end
      
    shared_examples_for "mismatching step" do
      it "redirects if wrong step is passed in unless the user is an admin" do
          get edit_project_step_path(@project, step: :completed) 
          expect(response).to have_http_status(@user.admin? ? :success : :redirect)
      end
    end
      
    shared_examples_for "valid request" do
      it "renders edit template" do
          get edit_project_step_path(@project, step: @project.aasm.current_state)
          expect(response).to render_template :edit
      end
    end

    describe "Edit project step path for projects#edit" do
        context "logged in as admin" do
          before :each do
              @user = FactoryGirl.create(:admin)
              @project = FactoryGirl.create(:project)
              sign_in(@user)
              @user.add_role :leader, @project
              @user.projects << @project
          end
          
          it_should_behave_like "valid id and step"
          it_should_behave_like "mismatching step"
          it_should_behave_like "valid request"
        end
        
        context "logged in as user" do
          before :each do
              @user = FactoryGirl.create(:user)
              @project = FactoryGirl.create(:project)
              sign_in(@user)
              @user.add_role :employee, @project
              @user.projects << @project
          end
            
          it_should_behave_like "valid id and step"
          it_should_behave_like "mismatching step"
          it_should_behave_like "valid request"
        end
    end
end