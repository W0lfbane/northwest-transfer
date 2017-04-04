require 'rails_helper'

RSpec.describe RolesController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:role) }

  describe "GET #index" do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    context "with admin" do
      login_admin
      it "recieve a 200 response" do
        get :index, params: {resource_controller: 'users', resource_id: @user.id }
        expect(response.status).to eq(200)
      end
    end

    context "with user" do
      login_user
      it "recieve a 200 response" do
        get :index, params: {resource_controller: 'users', resource_id: @user.id }
        expect(response.status).to eq(200)
      end
    end

    context "with non-user" do
      it "recieve a 302 response" do
        get :index, params: {resource_controller: 'users', resource_id: @user.id }
        expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #show" do
    before :each do
      @user = FactoryGirl.create(:user)
      @role = @user.roles.create(attributes_for(:role))
    end

    context "with admin" do
      login_admin
      it "recieve a 200 response" do
        get :show, params: {resource_controller: 'users', resource_id: @user.id, id: @role.id }
        expect(response.status).to eq(200)
      end
    end

    context "with user" do
      login_user
      it "recieve a 200 response" do
        get :show, params: {resource_controller: 'users', resource_id: @user.id, id: @role.id }
        expect(response.status).to eq(200)
      end
    end

    context "with non-user" do
      it "recieve a 302 response" do
        get :show, params: {resource_controller: 'users', resource_id: @user.id, id: @role.id }
        expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #new" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    context "with admin" do
      login_admin
      it "assigns a new role as @role" do
        get :new, params: {resource_controller: 'users', resource_id: @user.id}
        expect(assigns(:role)).to be_a_new(Role)
      end
    end

    context "with user" do
      login_user
      it "assigns a new role as @role" do
        get :new, params: {resource_controller: 'users', resource_id: @user.id}
        expect(assigns(:role)).to be_a_new(Role)
      end
    end

    context "with non-user" do
      it "assigns a new role as @role" do
        get :new, params: {resource_controller: 'users', resource_id: @user.id}
          expect(response.status).to eq(302)
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @user = FactoryGirl.create(:user)
      @role = @user.roles.create(attributes_for(:role))
    end

    context "with admin" do
      login_admin
      it "assigns the requested role as @role" do
        get :edit, params: {resource_controller: 'users', resource_id: @user.id, id: @role.id}
        expect(assigns(:role)).to eq(@role)
      end
    end

    context "with user" do
      login_user
      it "assigns the requested role as @role" do
        get :edit, params: {resource_controller: 'users', resource_id: @user.id, id: @role.id}
        expect(assigns(:role)).to eq(@role)
      end
    end

    context "with non-user" do
      it "assigns the requested role as @role" do
        get :edit, params: {resource_controller: 'users', resource_id: @user.id, id: @role.id}
        expect(response.status).to eq(302)
      end
    end
  end

  describe "POST #create" do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    context "with admin" do
      login_admin
      it "creates a new Role" do
        expect {
          post :create, params: {resource_controller: 'users', resource_id: @user.id, role: valid_attributes}
        }.to change(Role, :count).by(1)
      end

      it "assigns a newly created role as @role" do
          post :create, params: {resource_controller: 'users', resource_id: @user.id, role: valid_attributes}
        expect(assigns(:role)).to be_a(Role)
        expect(assigns(:role)).to be_persisted
      end
    end

    context "with user" do
      login_user
      it "creates a new Role" do
        expect {
          post :create, params: {resource_controller: 'users', resource_id: @user.id, role: valid_attributes}
        }.to change(Role, :count).by(1)
      end

      it "assigns a newly created role as @role" do
          post :create, params: {resource_controller: 'users', resource_id: @user.id, role: valid_attributes}
        expect(assigns(:role)).to be_a(Role)
        expect(assigns(:role)).to be_persisted
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @user = FactoryGirl.create(:user)
      @role = @user.roles.create(attributes_for(:role))
    end

    context "with admin" do
      login_admin
      let(:new_attributes) { FactoryGirl.attributes_for(:role, name: 'new' )}

      it "updates the requested role" do
        put :update, params: {id: @role.id, role: new_attributes, resource_controller: 'users', resource_id: @user.id}
        @role.reload
        expect(@role.name).to eq('new')
      end

      it "assigns the requested role as @role" do
        put :update, params: {id: @role.id, role: new_attributes, resource_controller: 'users', resource_id: @user.id}
        expect(assigns(:role)).to eq(@role)
      end
    end

    context "with user" do
      login_user
      let(:new_attributes) { FactoryGirl.attributes_for(:role, name: 'new' )}

      it "updates the requested role" do
        put :update, params: {id: @role.id, role: new_attributes, resource_controller: 'users', resource_id: @user.id}
        @role.reload
        expect(@role.name).to eq('new')
      end

      it "assigns the requested role as @role" do
        put :update, params: {id: @role.id, role: new_attributes, resource_controller: 'users', resource_id: @user.id}
        expect(assigns(:role)).to eq(@role)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested role" do
      role = Role.create! valid_attributes
      expect {
        delete :destroy, params: {id: role.to_param}, session: valid_session
      }.to change(Role, :count).by(-1)
    end

    it "redirects to the roles list" do
      role = Role.create! valid_attributes
      delete :destroy, params: {id: role.to_param}, session: valid_session
      expect(response).to redirect_to(roles_url)
    end
  end

end
