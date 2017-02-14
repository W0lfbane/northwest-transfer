require 'rails_helper'

RSpec.describe "Custom Routes", :type => :request do
  describe "custom index route for groups" do
    context "logged in as user" do
      before :each do
        @user = FactoryGirl.create(:user)
        @group = FactoryGirl.create(:group)
        sign_in(@user)
      end
      
      it "successfully loads page" do
        get user_groups_path
        expect(response).to have_http_status(:success)
      end
      
      it "assigns user owned groups to instance variable" do
        @user.groups << @group
        get user_groups_path
        expect(assigns(:groups).count).to eql @user.groups.count
        expect(assigns(:groups)).to include @group
      end
    end
    
    context "logged in as admin" do
      before :each do 
        @admin = FactoryGirl.create(:admin)
        @group = FactoryGirl.create(:group)
        sign_in(@admin)
      end
      
      it "does not return all groups if admin" do
        get user_groups_path
        expect(assigns(:groups).count).to eql 0
        expect(assigns(:groups)).to_not include @group
      end
      
      it "returns groups that belong to admin" do
        @admin.groups << @group
        get user_groups_path
        expect(assigns(:groups).count).to eql @admin.groups.count
        expect(assigns(:groups)).to include @group
      end
    end
  end
        
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
  
  describe "custom user projects path for projects#index" do
    shared_examples_for "with permissions" do
      it "successfully loads page" do
        get user_projects_path
        expect(response).to have_http_status(:success)
      end 
      
      it "assigns user owned groups to instance variable" do
        get user_projects_path
        expect(assigns(:projects).count).to eql user.projects.count
        expect(assigns(:projects)).to include project
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
      
      it_should_behave_like "with permissions" do
        let(:user) { @user }
        let(:project) { @project }
      end
    end
  
    context "logged in as admin" do
      before :each do
        @admin = FactoryGirl.create(:admin)
        @project = FactoryGirl.create(:project)
        sign_in(@admin)
        @admin.add_role :leader, @project
        @admin.projects << @project
      end
      
      it_should_behave_like "with permissions" do
        let(:user) {@admin}
        let(:project) {@project}
      end
      
      it "assigns only admin owned projects to instance variable" do
        new_project = FactoryGirl.create(:project)
        get user_projects_path
        expect(assigns(:projects).count).to eql @admin.projects.count
        expect(assigns(:projects)).to_not include new_project
      end
    end
  end
  
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