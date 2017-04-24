class DocumentsController < ApplicationController
  include Concerns::Resource::State::ResourceStateChange
  include Concerns::Resource::Nested::SetResource

  before_action :authenticate_user!
  before_action :set_resource
  before_action :set_project
  before_action :set_document, except: [:index, :create]
  before_action :authorize_document, except: [:index, :create]

  def index
    @documents = policy_scope(@resource.documents)
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create

    @document = @resource.documents.build(document_params)
    authorize_document

    respond_to do |format|
      if @document.save
        format.html { redirect_to document_path(id: @document), notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: document_path(id: @document) }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to projects_document_path(resource: @project, id: @document), notice: 'document was successfully updated.' }
        format.json { render :show, status: :ok, location: document_path(id: @document) }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_document
      @document = params[:id] ? @resource.documents.find(params[:id]) : @resource.documents.build
    end
    def set_project
      @project = @resource
    end
    def authorize_document
      authorize @document
    end

    def document_params
      params.require(:document).permit(:title,:signature, :resource_state, :completion_date, :customer_firstname, :customer_lastname, :ems_order_no, :technician, :shipper, :make, :brand, :item_model, :age, :itm_length, :itm_width, :itm_height, :itm_name, :itm_condition)
    end
end
