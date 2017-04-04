require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.create(:document)  }

  describe "GET #show" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = FactoryGirl.create(:document)
    end

    context "with admin" do
      login_admin
      it "recieves a 200 response" do
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
      @doc = FactoryGirl.create(:document)
    end

    context "with admin" do
      login_admin
      it "recieves a 200 response" do
        get :new, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with user" do
      login_user
      it "recievesa a 200 response" do
        get :new, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(200)
      end
    end

    context "with non-user" do
      it "recievesa a 302 response" do
        get :new, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #edit" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = FactoryGirl.create(:document)
    end

    context "with admin" do
      login_admin
      it "assigns the requested note as @note" do
        get :edit, params: {id: @doc.id, project_id: @project.id}
        expect(assigns(:note)).to eq(@note)
      end
    end

    context "with user" do
      login_user
      it "assigns the requested note as @note" do
        get :edit, params: {id: @doc.id, project_id: @project.id}
        expect(assigns(:note)).to eq(@note)
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
      @doc = FactoryGirl.create(:document)
    end

    context "with admin" do
      login_admin
      it "creates a new Note" do
        expect {
          post :create, params: {project_id: @project.id, document: valid_attributes}
        }.to change(Document, :count).by(1)
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

      it "raises an error" do
        expect {
          post :create, params: {project_id: @project.id, document: valid_attributes}
        }.to raise_error(Pundit::NotAuthorized)
      end
    end
  end

  describe "PUT #update" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = FactoryGirl.create(:document)
    end

    context "with admin" do
      login_admin
      let(:new_attributes) { FactoryGirl.attributes_for(:document, title: 'new')}

      it "updates the requested document" do
        put :update, params: {id: @doc.id, document: new_attributes, project_id: @project.id}
        @doc.reload
        expect(@doc.title).to eq('new')
      end

      it "assigns the requested note as @doc" do
        put :update, params: {id: @doc.id, document: new_attributes, project_id: @project.id}
        expect(assigns(:docuement)).to eq(@doc)
      end
    end

    context "with user" do
      login_user
      let(:new_attributes) { FactoryGirl.attributes_for(:document, title: 'new')}

      it "updates the requested document" do
        put :update, params: {id: @doc.id, document: new_attributes, project_id: @project.id}
        @doc.reload
        expect(@doc.title).to eq('new')
      end

      it "assigns the requested note as @doc" do
        put :update, params: {id: @doc.id, document: new_attributes, project_id: @project.id}
        expect(assigns(:docuement)).to eq(@doc)
      end
    end
  end

  describe "DELETE #destroy" do

    before :each do
      @project = FactoryGirl.create(:project)
      @doc = FactoryGirl.create(:document)
    end

    context "with admin" do
      login_admin
      it "destroys the requested note" do
        binding.pry
        expect {
          delete :destroy, params: {id: @doc.id, project_id: @project.id}
        }.to change(Note, :count).by(-1)
      end
    end

    context "with user" do
      login_user
      it "destroys the requested note" do
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
