require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  
  shared_examples_for "does not have permission" do | http_verb, controller_method | 
    it "should raise a Pundit exception" do
      expect do
        send(http_verb, controller_method, params: sent_params)
      end.to raise_error(Pundit::NotAuthorizedError)
    end
  end
  
  shared_examples_for "invalid id" do | http_verb, controller_method | 
    it "should raise an ActiveRecord exception" do
      expect do
        send(http_verb, controller_method, params: {id: -1})
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  shared_examples_for "valid id" do
    it "should find the correct project" do
      expect(assigns(:group)).to eql test_group
    end
  end
  
  describe "GET #index" do
    
    context "as user" do
      login_user
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it "renders index template" do
        get :index
        expect(response).to render_template :index
      end
      
      it "returns 0 groups if user does not belong to any" do
        get :index
        expect(assigns(:groups).count).to eql 0
      end
    end
    
    context "as user with groups" do
      login_group_user
      
      it "returns groups to which user belongs" do
        get :index
        expect(assigns(:groups).count).to eql subject.current_user.groups.count
        expect(assigns(:groups)).to include subject.current_user.groups.last
      end
    end
    
    context "as user with groups" do
      login_admin
      
      it "returns all groups" do
        get :index
        expect(assigns(:groups).count).to eql Group.count
      end
    end
  end
  
  describe "GET #show" do
    context "logged in as non-group user" do
      login_user
      before :each do
        @test_group = FactoryGirl.create(:group)
      end

      it_should_behave_like "does not have permission", :get, :show do 
        let (:sent_params) {{id: @test_group}}
      end
      
      it_should_behave_like "invalid id", :get, :show
    end
    
    shared_examples_for "has appropriate permissions" do
      it_should_behave_like "valid id"
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "renders show template" do
        expect(response).to render_template :show
      end
    end
    
    context "logged in as group user" do
      login_group_user
      before :each do
        @test_group = subject.current_user.groups.last
        get :show, params: {id: @test_group}
      end
      
      it_should_behave_like "has appropriate permissions" do 
        let(:test_group) {@test_group}
      end
    end
    
    context "logged in as admin" do
      login_admin
      before :each do
        @test_group = FactoryGirl.create(:group)
        get :show, params: {id: @test_group}
      end
      
      it_should_behave_like "has appropriate permissions" do 
        let(:test_group) {@test_group}
      end
    end
  end
  
  describe "GET #new" do
    shared_examples_for "has appropriate permissions" do
     
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "renders show template" do
        expect(response).to render_template :new
      end
    end
    
    context "logged in as non-group user" do
      login_user
      before :each do
        get :new
      end
      it_should_behave_like "has appropriate permissions"
    end
    
    context "logged in as group user" do
      login_group_user
      before :each do
        get :new
      end
      it_should_behave_like "has appropriate permissions"
    end
    
    context "logged in as admin" do
      login_admin
      before :each do
        get :new
      end
      it_should_behave_like "has appropriate permissions"
    end
  end
  
  describe "GET #edit" do
    
    shared_examples_for "has appropriate permissions" do
      it_should_behave_like "valid id"
      
      it_should_behave_like "invalid id", :get, :edit
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "renders show template" do
        expect(response).to render_template :edit
      end
    end
    
    context "logged in as non-group user" do
      login_user
      before :each do
        @test_group = FactoryGirl.create(:group)
        get :edit, params: {id: @test_group}
      end
    end
    
    context "logged in as group user" do
      login_group_user
      before :each do
        @test_group = subject.current_user.groups.last
        get :edit, params: {id: @test_group}
      end
      
      it_should_behave_like "has appropriate permissions" do 
        let(:test_group) {@test_group}
      end
    end
    
    context "logged in as admin" do
      login_admin
      before :each do
        @test_group = FactoryGirl.create(:group)
        get :edit, params: {id: @test_group}
      end
      
      it_should_behave_like "has appropriate permissions" do 
        let(:test_group) {@test_group}
      end
    end
  end
  
  describe "POST #create" do
    let (:valid_params) { { group: FactoryGirl.attributes_for(:group) } }
    let (:invalid_params) { { group: FactoryGirl.attributes_for(:group, name: nil) } }
    login_user
    
    context "with valid parameters" do
      it "increases amount of groups by 1" do
        expect {
          post :create, params: valid_params
        }.to change(Group, :count).by(1)
      end
      
      it "redirects to new group" do
        post :create, params: valid_params
        expect(response).to redirect_to Group.last
      end
    end
    
    context "with invalid parameters" do
      it "does not increase amount of groups" do
        expect {
          post :create, params: invalid_params
        }.to_not change(Group, :count)
      end
      
      it "rerenders new template" do
        post :create, params: invalid_params
        expect(response).to render_template :new
      end
    end
  end
  
  describe "PUT #update" do
    let (:valid_params) { FactoryGirl.attributes_for(:group, name: "new name") }
    let (:invalid_params) { FactoryGirl.attributes_for(:group, name: nil) }
    
    context "logged in as non-group user" do
      login_user
      before :each do
        @test_group = FactoryGirl.create(:group)
      end

      it_should_behave_like "does not have permission", :put, :update do 
        let (:sent_params) {{id: @test_group}}
      end
    end
    
    shared_examples_for "has appropriate permissions" do
      
      context "valid_params" do
        before(:each) do
          put :update, params: {id: test_group, group: valid_params}
          test_group.reload
        end
        
        it_should_behave_like "valid id"

        it "should update object paramaters" do
          expect(test_group.name).to eql valid_params[:name]
          expect(test_group.created_at).to_not eql test_group.updated_at
        end
        
        it "should redirect to group page when successful" do
          expect(response).to redirect_to test_group
        end
      end
      
      context "with invalid parameters" do
        before(:each) do
          @original_name = test_group.name
          put :update, params: { id: test_group.id, group: invalid_params }
          test_group.reload
        end
        
        it_should_behave_like "invalid id", :put, :update
      
        it "should not update object paramaters" do
          expect(test_group.name).to eql @original_name
          expect(test_group.created_at).to eql test_group.updated_at
        end
        
        it "should rerender edit page when update unsuccessful" do
          expect(response).to render_template :edit
        end
      end
    end
    
    context "logged in as group user" do
      login_group_user
      it_should_behave_like "has appropriate permissions" do
        let(:test_group) {subject.current_user.groups.last}
      end
    end
    
    context "logged in as admin" do
      login_admin
      it_should_behave_like "has appropriate permissions" do
        let(:test_group) {FactoryGirl.create(:group)}
      end
    end
  end
  
  describe "DELETE #destroy" do

    
    context "as user" do
      login_user
      before :each do
        @test_group = FactoryGirl.create(:group)
      end
      
      it_should_behave_like "does not have permission", :delete, :destroy do 
        let (:sent_params) {{id: @test_group}}
      end
    end
    
    shared_examples_for "has appropriate permissions" do
      it_should_behave_like "invalid id", :delete, :destroy
      
      it "should find the correct group" do
        delete :destroy, params: { id: test_group }
        expect(assigns(:group)).to eql test_group
      end
      
      it "deactivates the group in the database" do
        expect do
          delete :destroy, params: { id: test_group }
        end.to change(Group.deactivated, :count).by(1)
      end
      
      it "redirects to the groups index" do
        delete :destroy, params: {id: test_group}
        expect(response).to redirect_to groups_url
      end
    end
    
    context "logged in as group user" do
      login_group_user
      it_should_behave_like "has appropriate permissions" do
        let(:test_group) {subject.current_user.groups.last}
      end
    end
    
    context "logged in as admin" do
      login_admin
      it_should_behave_like "has appropriate permissions" do
        let(:test_group) {FactoryGirl.create(:group)}
      end
    end
  end
  
end
