require 'rails_helper'

RSpec.describe "Custom Routes", :type => :request do
  describe "custom index route for groups" do
    
    context "logged in as user" do
      before :each do
        @user = FactoryGirl.create(:user)
        @group = FactoryGirl.create(:group)
        sign_in(@user)
      end
      
      it "has success http status" do
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
    
    context "logged in as user" do
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
  
  describe "custom schedule path for projects#index" do
    context "logged in as user" do
      before :each do
        @user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, start_date: Date.today)
        sign_in(@user)
      end
      
      # it "has success http status" do
      #   get schedule_path
      #   expect(response).to have_http_status(:success)
      # end 
      
      it "assigns user owned groups to instance variable" do
        @user.add_role :leader, @project
        @user.projects << @project
        get schedule_path
        expect(assigns(:projects).count).to eql @user.projects.count
        expect(assigns(:projects)).to include @project
      end
      
      # it "assigns user owned projects to instance variable" do
      #   @project.start_date = DateTime.new(2011, 1, 1)
      #   @user.project << @project
      #   get schedule_path
      #   expect(assigns(:projects).count).to_not eql @user.projects.count
      #   expect(assigns(:projects)).to_not include @project
      # end
    end
  end
  
end