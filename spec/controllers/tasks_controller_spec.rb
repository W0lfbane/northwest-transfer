require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  let(:valid_params) { FactoryGirl.attributes_for(:task, :project_id => @project.id) }
  let(:invalid_params) { FactoryGirl.attributes_for(:task, :name => nil)}


  before (:each) do
    @project = FactoryGirl.create(:project)
      @task = Task.create! valid_params
  end

  describe "GET #index" do
    context "non-registered user" do
        it "will redirect to login page" do
          get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
          expect(response.status).to eq(302)
        end
      end

    context "user" do
      login_user

      it " will have a succesful response" do
        get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
        expect(response.status).to eq(200)
      end

      it " will render the :index template " do
        get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
        expect(response).to render_template("index")
      end

      it "will assign the resource.tasks as @tasks " do
        get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
        expect(assigns(:tasks)).to eq([@task])
      end
    end

    context "admin" do
      login_admin

      it " will have a successful response " do
        get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
        expect(response.status).to eq(200)
        end

      it " will render the :index template " do
        get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
        expect(response).to render_template("index")
        end

      it "will assign the resource.tasks as @tasks " do
        get :index, params: {:resource_controller => "projects", :resource_id => @project.id }
        expect(assigns(:tasks)).to eq([@task])
        end
      end
    end

  describe "GET #show" do

    context "non-registered user" do
      it "will redirect to login page" do
      get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response.status).to eq(302)
      end
    end

    context "admin" do
      login_admin
      it "will have a succesful response" do
        get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response.status).to eq(200)
      end

      it "renders the :show template" do
        get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response).to render_template("show")
        end

      it "assigns the requested task as @task" do
        get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(assigns(:task)).to eq(@task)
        end
      end

    context "user" do
      login_user
      it "will have a succesful response" do
        get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response.status).to eq(200)
        end

      it "renders the :show template" do
        get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response).to render_template("show")
        end

      it "assigns the requested task as @task" do
        get :show, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(assigns(:task)).to eq(@task)
        end
      end
    end

  describe "GET #new" do

    context "non-registered user" do
      it "will redirect to login page" do
      get :new, params: {:resource_controller => "projects", :resource_id => @project.id}
        expect(response.status).to eq(302)
      end
    end

    context "admin" do
      login_admin
    it "have a succesful response" do
      get :new, params: {:resource_controller => "projects", :resource_id => @project.id}
        expect(response.status).to eq(200)
      end

    it "assigns a new task as @task" do
      get :new, params: {:resource_controller => "projects", :resource_id => @project.id}
      expect(response).to render_template("new")
      end

    it "assigns a new task as @task" do
      get :new, params: {:resource_controller => "projects", :resource_id => @project.id}
      expect(assigns(:task)).to be_a_new(Task)
      end
    end
  end

  describe "GET #edit" do

    context "admin" do
      login_admin

      it "have a succesful response" do
        get :edit, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response.status).to eq(200)
      end

      it "it renders the :edit template" do
        get :edit, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(response).to render_template("edit")
      end

      it "assigns a new task as @task" do
        get :edit, params: {:resource_controller => "projects", :resource_id => @project.id, :id => @task.to_param}
        expect(assigns(:task)).to eq(@task)
      end
    end
  end

  describe "POST #create" do
    context "admin" do
      login_admin

        context "with valid params" do
          it "creates a new Task" do
            expect {
              post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: valid_params}
            }.to change(Task, :count).by(1)
          end

          it "creates a new Task" do
            expect {
              post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: valid_params}
            }.to change(Task, :count).by(1)
          end

          it "assigns a newly created task as @task" do
            post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: valid_params}
            expect(assigns(:task)).to be_a(Task)
            expect(assigns(:task)).to be_persisted
          end

          it "redirects to the created task" do
            post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: valid_params}
            expect(response).to redirect_to(task_path(id: Task.last))
          end
        end

        context "with invalid params" do

          it "will not increase the count of Tasks" do
            expect {
              post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: invalid_params}
            }.to_not change(Task, :count)
          end
          it "assigns a newly created but unsaved task as @task" do
            post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: invalid_params}
            expect(assigns(:task)).to be_a_new(Task)
          end

          it "re-renders the 'new' template" do
            post :create, params: {:resource_controller => "projects", :resource_id => @project.id, task: invalid_params}
            expect(response).to render_template("new")
          end
        end
      end
    end

  describe "PUT #update" do
    let (:new_params) {FactoryGirl.attributes_for(:task, :name => "Updated Name")}

    context "admin" do
      login_admin

      context "update with valid params" do
        before :each do
          @task = Task.create! valid_params
          put :update, params: {:resource_controller => "projects", :resource_id => @project.id, id: @task, task: new_params}
          @task.reload
        end

        it "will find the correct task" do
          expect(assigns(:task)).to eql(@task)
        end


        it "will update the task" do
          expect(@task.name).to eq new_params[:name]
          expect(@task.created_at).to_not eql(@task.updated_at)
          end

        it "will redirect to task page on success" do
          expect(response).to redirect_to(task_path(id: @task))
        end
      end

      context "with invalid params" do
        before :each do
          @task = Task.create! valid_params
          put :update, params: {:resource_controller => "projects", :resource_id => @project.id, id: @task, task: invalid_params}
          @task.reload
        end

        it "will find the correct task" do
          expect(assigns(:task)).to eql(@task)
        end

        it "will not update parameters" do
          expect(@task.name).to_not eq(invalid_params[:name])
          expect(@task.created_at).to eql(@task.updated_at)
        end

        it "will re-render edit page" do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "as admin" do
      login_admin

      it "will find the correct task" do
        task = Task.create! valid_params
        delete :destroy, params: {:resource_controller => "projects", :resource_id => @project.id, id: task}
        expect(assigns(:task)).to eql(task)
        end

      it "will delete the task" do
        task = Task.create! valid_params
        expect {
          delete :destroy, params: {:resource_controller => "projects", :resource_id => @project.id, id:task}
        }.to change(Task, :count).by(-1)
        end

      it "will redirect to tasks page" do
        task = Task.create! valid_params
        delete :destroy, params: {:resource_controller => "projects", :resource_id => @project.id, id: task}
        expect(response).to redirect_to(:action => :index)
      end
    end
  end
end
