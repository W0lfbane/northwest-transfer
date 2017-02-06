require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  
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
      it "should raise an exception if not an admin or group user" do
        test_group = FactoryGirl.create(:group)
        expect do
          put :update, params: { id: test_group }
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
    
    shared_examples_for "has appropriate permissions" do
      context "invalid id" do 
        it "should return an ActiveRecord error if the group id does not exist" do
          expect do
             put :update, params: {id: -1, group: valid_params}
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
      
      context "valid_params" do
        before(:each) do
          put :update, params: {id: test_group, group: valid_params}
          test_group.reload
        end
        
        it "should find the correct group" do
          expect(assigns(:group)).to eql test_group
        end

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
          put :update, params: { id: test_group.id, group: invalid_params }
          test_group.reload
        end
      
        it "should not update object paramaters" do
          expect(test_group.name).to eql "test name"
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
      
      it "should raise an exception if not an admin" do
        test_group = FactoryGirl.create(:group)
        expect do
          delete :destroy, params: { id: test_group }
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
    
    shared_examples_for "has appropriate permissions" do
      it "should return an ActiveRecord error if the group id does not exist" do
        expect do
          delete :destroy, params: {id: -1}
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
      
      it "should find the correct group" do
        delete :destroy, params: { id: test_group }
        expect(assigns(:group)).to eql test_group
      end
      
      it "deletes the group from the database" do
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
