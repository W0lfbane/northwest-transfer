require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:document)  }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:document, title: nil)  }

  describe "GET #show" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = @project.create_document(valid_attributes)
    end

    context "with admin" do
      login_admin

      it "receives a 200 response" do
        get :show, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with user" do
      login_user

      it "recieves a 200 response" do
        get :show, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with non-user" do
      it "recieves a 200 response" do
        get :show, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #new" do

    before :each do
      @project = FactoryGirl.create(:project)
    end

    context "with admin" do
      login_admin

      it "recieves a 200 response" do
        get :new, params: {project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with user" do
      login_user

      it "recievesa a 200 response" do
        get :new, params: {project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with non-user" do
      it "recievesa a 302 response" do
        get :new, params: {project_id: @project.id}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #edit" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = @project.create_document(valid_attributes)
    end

    context "with admin" do
      login_admin

      it "recievesa a 200 response" do
        get :edit, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with user" do
      login_user

      it "recievesa a 200 response" do
        get :edit, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with non-user" do
      it "recievesa a 302 response" do
        get :edit, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "POST #create" do

    before :each do
      @project = FactoryGirl.create(:project)
    end

    context "with admin" do
      login_admin

      it "creates a new document" do
        expect {
          post :create, params: { project_id: @project.id, document: valid_attributes }
        }.to change(Document, :count).by(1)
      end

      it "not create if title is nil" do
        expect {
          post :create, params: { project_id: @project.id, document: invalid_attributes }
        }.to change(Document, :count).by(0)
      end

      it "assigns a newly created document as @doc" do
        post :create, params: {project_id: @project.id, document: valid_attributes}
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end
    end

    context "with user" do
      login_user

      it "creates a new Note" do
        expect {
          post :create, params: {project_id: @project.id, document: valid_attributes}
        }.to change(Document, :count).by(1)
      end

      it "not create if title is nil" do
        expect {
          post :create, params: {project_id: @project.id, document: invalid_attributes }
        }.to change(Document, :count).by(0)
      end

      it "assigns a newly created document as @doc" do
        post :create, params: {project_id: @project.id, document: valid_attributes}
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end
    end

    context "with non-user" do
      it "gets redirected" do
        post :create, params: {project_id: @project.id, document: valid_attributes}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "PUT #update" do

    let(:new_attributes) { FactoryGirl.attributes_for(:document, title: 'new')}

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = @project.create_document(FactoryGirl.attributes_for(:document))
    end

    context "with admin" do
      login_admin

      it "updates the requested document" do
        put :update, params: {id: @doc.id, document: new_attributes, project_id: @project.id}
        @doc.reload
        expect(@doc.title).to eq('new')
      end
    end

    context "with user" do
      login_user

      it "updates the requested document" do
        put :update, params: {id: @doc.id, document: new_attributes, project_id: @project.id}
        @doc.reload
        expect(@doc.title).to eq('new')
      end
    end
  end

  describe "DELETE #destroy" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = @project.create_document(valid_attributes)
    end

    context "with admin" do
      login_admin

      it "destroys the requested document" do
        expect {
          delete :destroy, params: {id: @doc.id, project_id: @project.id}
        }.to change(Document, :count).by(-1)
      end
    end

    context "with user" do
      login_user

      it "destroys the requested docuemnt" do
        expect {
          delete :destroy, params: {id: @doc.id, project_id: @project.id}
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "with non-user" do
      it "destroys the requested note" do
        delete :destroy, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(302)
      end
    end
  end
end
