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
      it "recievesa a 200 response" do
        get :new, params: {id: @doc.id, project_id: @project.id}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested note as @note" do
      note = Note.create! valid_attributes
      get :edit, params: {id: note.to_param}, session: valid_session
      expect(assigns(:note)).to eq(note)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Note" do
        expect {
          post :create, params: {note: valid_attributes}, session: valid_session
        }.to change(Note, :count).by(1)
      end

      it "assigns a newly created note as @note" do
        post :create, params: {note: valid_attributes}, session: valid_session
        expect(assigns(:note)).to be_a(Note)
        expect(assigns(:note)).to be_persisted
      end

      it "redirects to the created note" do
        post :create, params: {note: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Note.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved note as @note" do
        post :create, params: {note: invalid_attributes}, session: valid_session
        expect(assigns(:note)).to be_a_new(Note)
      end

      it "re-renders the 'new' template" do
        post :create, params: {note: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested note" do
        note = Note.create! valid_attributes
        put :update, params: {id: note.to_param, note: new_attributes}, session: valid_session
        note.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested note as @note" do
        note = Note.create! valid_attributes
        put :update, params: {id: note.to_param, note: valid_attributes}, session: valid_session
        expect(assigns(:note)).to eq(note)
      end

      it "redirects to the note" do
        note = Note.create! valid_attributes
        put :update, params: {id: note.to_param, note: valid_attributes}, session: valid_session
        expect(response).to redirect_to(note)
      end
    end

    context "with invalid params" do
      it "assigns the note as @note" do
        note = Note.create! valid_attributes
        put :update, params: {id: note.to_param, note: invalid_attributes}, session: valid_session
        expect(assigns(:note)).to eq(note)
      end

      it "re-renders the 'edit' template" do
        note = Note.create! valid_attributes
        put :update, params: {id: note.to_param, note: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested note" do
      note = Note.create! valid_attributes
      expect {
        delete :destroy, params: {id: note.to_param}, session: valid_session
      }.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = Note.create! valid_attributes
      delete :destroy, params: {id: note.to_param}, session: valid_session
      expect(response).to redirect_to(notes_url)
    end
  end
end
