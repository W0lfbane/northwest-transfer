require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  
  describe "POST #create" do
    let (:valid_params) { { project: FactoryGirl.attributes_for(:project) } }
    let (:invalid_params) { { project: FactoryGirl.attributes_for(:project, title: nil) } }
    
    shared_examples_for "does not have permission" do
      it "should raise an exception if not an admin" do
        expect do
          post :create, params: valid_params
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
    
    context "logged in as user" do
      login_user
      it_should_behave_like "does not have permission"
    end
    
    context "logged in as project user" do
      login_project_user
      it_should_behave_like "does not have permission"
    end
    
    context "logged in as admin" do
      login_admin
      
      context "with valid parameters" do
        it "increases amount of projects by 1" do
          expect {
            post :create, params: valid_params
          }.to change(Project, :count).by(1)
        end
        
        it "redirects to new project" do
          post :create, params: valid_params
          expect(response).to redirect_to Project.last
        end
      end
      
      context "with invalid parameters" do
        it "does not increase amount of projects" do
          expect {
            post :create, params: invalid_params
          }.to_not change(Project, :count)
        end
        
        it "rerenders new template" do
          post :create, params: invalid_params
          expect(response).to render_template :new
        end
      end
    end
  end
  
  describe "PUT #update" do
    let (:valid_params) { FactoryGirl.attributes_for(:project, title: "new title") }
    let (:invalid_params) { FactoryGirl.attributes_for(:project, title: nil) }
    
    context "logged in as non-project user" do
      login_user
      it "should raise an exception if not an admin or project user" do
        test_project = FactoryGirl.create(:project)
        expect do
          put :update, params: { id: test_project }
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
    
    shared_examples_for "has appropriate permissions" do
      context "invalid id" do 
        it "should return an ActiveRecord error if the project id does not exist" do
          expect do
             put :update, params: {id: -1, project: valid_params}
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
      
      context "with valid_params" do
        before(:each) do
          put :update, params: {id: test_project, project: valid_params}
          test_project.reload
        end
        
        it "should find the correct project" do
          expect(assigns(:project)).to eql test_project
        end

        it "should update object paramaters" do
          expect(test_project.title).to eql valid_params[:title]
          expect(test_project.created_at).to_not eql test_project.updated_at
        end
        
        it "should redirect to project page when successful" do
          expect(response).to redirect_to test_project
        end
      end
      
      context "with invalid parameters" do
        before(:each) do
          put :update, params: { id: test_project.id, project: invalid_params }
          test_project.reload
        end
      
        it "should not update object paramaters" do
          expect(test_project.title).to eql "test title"
          expect(test_project.created_at).to eql test_project.updated_at
        end
        
        it "should rerender edit page when update unsuccessful" do
          expect(response).to render_template :edit
        end
      end
    end
    
    context "logged in as project user" do
      login_project_user
      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {subject.current_user.projects.last}
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "as user" do
      login_user
      
      it "should raise an exception if not an admin" do
        test_project = FactoryGirl.create(:project)
        expect do
          delete :destroy, params: { id: test_project }
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
    
    shared_examples_for "has appropriate permissions" do
      it "should return an ActiveRecord error if the project id does not exist" do
        expect do
          delete :destroy, params: {id: -1}
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
      
      it "should find the correct project" do
        delete :destroy, params: { id: test_project }
        expect(assigns(:project)).to eql test_project
      end
      
      it "deactivates the project in the database" do
        expect do
          delete :destroy, params: { id: test_project }
        end.to change(Project.deactivated, :count).by(1)
      end
      
      it "redirects to the projects index" do
        delete :destroy, params: {id: test_project}
        expect(response).to redirect_to projects_url
      end
    end
    
    context "logged in as project user" do
      login_project_user
      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {subject.current_user.projects.last}
      end
    end
    
    context "logged in as admin" do
      login_admin
      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {FactoryGirl.create(:project)}
      end
    end
  end
  
end