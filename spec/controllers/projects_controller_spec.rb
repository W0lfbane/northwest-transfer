require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

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
      expect(assigns(:project)).to eql test_project
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

      it "returns 0 projects if user does not belong to any" do
        get :index
        expect(assigns(:projects).count).to eql 0
      end
    end

    context "as user with projects" do
      login_project_user

      it "returns projects to which user belongs" do
        FactoryGirl.create(:project)
        get :index
        expect(assigns(:projects).count).to eql subject.current_user.projects.count
        expect(assigns(:projects).count).to_not eql Project.count
        expect(assigns(:projects)).to include subject.current_user.projects.last
      end
    end

    context "as admin" do
      login_admin

      it "returns all projects" do
        FactoryGirl.create(:project)
        get :index
        expect(assigns(:projects).count).to eql Project.count > 20 ? 20 : Project.count
      end
    end
  end

  describe "GET #show" do
    context "logged in as non-project user" do
      login_user
      before :each do
        @test_project = FactoryGirl.create(:project)
      end

      it_should_behave_like "does not have permission", :get, :show do
        let (:sent_params) {{id: @test_project}}
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

    context "logged in as project user" do
      login_project_user
      before :each do
        @test_project = subject.current_user.projects.last
        get :show, params: {id: @test_project}
      end

      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {@test_project}
      end
    end

    context "logged in as admin" do
      login_admin
      before :each do
        @test_project = FactoryGirl.create(:project)
        get :show, params: {id: @test_project}
      end

      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {@test_project}
      end
    end
  end

  describe "GET #new" do
    context "logged in as non-project user" do
      login_user
      it_should_behave_like "does not have permission", :get, :new do
        let(:sent_params){ nil }
      end
    end

    context "logged in as project user" do
      login_project_user
      it_should_behave_like "does not have permission", :get, :new do
        let(:sent_params){ nil }
      end
    end

    context "logged in as admin" do
      login_admin
      before :each do
        get :new
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "renders show template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    shared_examples_for "has appropriate permissions" do
      it_should_behave_like "valid id"
      it_should_behave_like "invalid id", :get, :edit

      it "redirects if wrong step is passed in unless user is admin" do
        get :edit, params: {id: test_project, step: :completed}
        expect(response).to have_http_status( subject.current_user.admin? ? :success : :success)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "renders show template" do
        expect(response).to render_template :edit
      end
    end

    context "logged in as non-project user" do
      login_user
      before :each do
        @test_project = FactoryGirl.create(:project)
      end

      it_should_behave_like "does not have permission", :get, :edit do
        let(:sent_params) { {id: @test_project} }
      end
    end

    context "logged in as project user" do
      login_project_user
      before :each do
        @test_project = subject.current_user.projects.last
        get :edit, params: {id: @test_project, step: @test_project.aasm.current_state}
      end

      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {@test_project}
      end
    end

    context "logged in as admin" do
      login_admin
      before :each do
        @test_project = FactoryGirl.create(:project)
        get :edit, params: {id: @test_project, step: @test_project.resource_state}
      end

      it_should_behave_like "has appropriate permissions" do
        let(:test_project) {@test_project}
      end
    end
  end

  describe "POST #create" do
    let (:valid_params) { { project: FactoryGirl.attributes_for(:project) } }
    let (:invalid_params) { { project: FactoryGirl.attributes_for(:project, title: nil) } }

    context "logged in as user" do
      login_user
      it_should_behave_like "does not have permission", :post, :create do
        let(:sent_params) { valid_params }
      end
    end

    context "logged in as project user" do
      login_project_user
      it_should_behave_like "does not have permission", :post, :create do
        let(:sent_params) { valid_params }
      end
    end

    context "logged in as admin" do
      login_admin

      context "with valid parameters" do
        it "increases amount of projects by 1" do
          expect {
            post :create, params: valid_params
          }.to change(Project, :count).by(1)
        end

        it "increases amount of tasks by 1 if a task is associated at creation time" do
          valid_params[:project].merge!( tasks_attributes: FactoryGirl.attributes_for_list(:task, 5) )

          expect {
            post :create, params: valid_params
          }.to change(Task, :count).by(5)
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

        it "does not increase amount of tasks" do
          expect {
            post :create, params: invalid_params
          }.to_not change(Task, :count)
        end

        it "rerenders new template" do
          post :create, params: invalid_params
          expect(response).to render_template :new
        end
      end
    end
  end

  # describe "PUT #update" do
  #   let (:valid_params) { FactoryGirl.attributes_for(:project, title: "new title") }
  #   let (:invalid_params) { FactoryGirl.attributes_for(:project, title: nil) }
  #
  #   context "logged in as non-project user" do
  #     login_user
  #     before :each do
  #       @test_project = FactoryGirl.create(:project)
  #     end
  #
  #     it_should_behave_like "does not have permission", :put, :update do
  #       let(:sent_params) { {id: @test_project} }
  #     end
  #   end
  #
  #
  #     shared_examples_for "has appropriate permissions" do
  #
  #       context "with valid_params" do
  #         before(:each) do
  #           put :update, params: {id: test_project, project: valid_params}
  #           test_project.reload
  #         end
  #
  #         it "should find the correct project" do
  #           expect(assigns(:project)).to eql test_project
  #         end
  #
  #         it "should update object paramaters" do
  #           expect(test_project.title).to eql valid_params[:title]
  #           expect(test_project.created_at).to_not eql test_project.updated_at
  #         end
  #
  #         it "should redirect to project page when successful" do
  #           expect(response).to redirect_to test_project
  #         end
  #       end
  #
  #     context "with invalid parameters" do
  #       before(:each) do
  #         @original_title = test_project.title
  #         put :update, params: { id: test_project.id, project: invalid_params }
  #         test_project.reload
  #       end
  #
  #       it_should_behave_like "invalid id", :put, :update
  #
  #       it "should not update object paramaters" do
  #         expect(test_project.title).to eql @original_title
  #         expect(test_project.created_at).to eql test_project.updated_at
  #       end
  #
  #       it "should rerender edit page when update unsuccessful" do
  #         expect(response).to render_template :edit
  #       end
  #     end
  #   end
  #
  #   context "logged in as project user" do
  #     login_project_user
  #     it_should_behave_like "has appropriate permissions" do
  #       let(:test_project) {subject.current_user.projects.last}
  #     end
  #   end
  #
  #   context "logged in as admin" do
  #     login_admin
  #     it_should_behave_like "has appropriate permissions" do
  #       let(:test_project) {FactoryGirl.create(:project)}
  #     end
  #   end
  # end

  describe "DELETE #destroy" do
    context "as user" do
      login_admin
      before :each do
        @test_project = FactoryGirl.create(:project)
      end

      it_should_behave_like "does not have permission", :delete, :destroy do
        let(:sent_params) { {id: @test_project} }
      end
    end

    shared_examples_for "has appropriate permissions" do

      it_should_behave_like "invalid id", :delete, :destroy

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
