require 'rails_helper'

RSpec.describe "Schedule Routes", :type => :request do
    describe "custom schedule path for projects#index" do
    shared_examples_for "with permissions" do
      it "successfully loads page" do
        get schedule_path
        expect(response).to have_http_status(:success)
      end 
      
      it "assigns user owned groups to instance variable" do
        get schedule_path
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
        get schedule_path
        expect(assigns(:projects).count).to eql @admin.projects.count
        expect(assigns(:projects)).to_not include new_project
      end
    end
  end
end