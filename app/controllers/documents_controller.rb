class DocumentsController < ApplicationController
  include Concerns::Resource::State::ResourceStateChange

  before_action :authenticate_user!
  before_action :set_project
  before_action :set_document, except: [:create, :new]
  before_action :authorize_document, except: [:create, :new]

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = @project.documents.new
    authorize_document

  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = @project.documents.new(document_params)
    authorize_document

    respond_to do |format|
      if @document.save
        format.html { redirect_to project_path(@project), notice: 'document was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @document] }
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
        format.html { redirect_to document_url(@document), notice: 'document was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @document] }
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
      format.html { redirect_to project_url(@project), notice: 'document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find(params[:resource_id])
    end

    def set_document
      # This will change upon document quantity semantics
      @document = params[:id] ? @project.documents.find(params[:id]) : @project.documents.build
    end

    def authorize_document
      authorize @document
    end

    def document_params
      params.require(:document).permit(:title,:signature, :resource_state, :completion_date, :customer_firstname, :customer_lastname, :ems_order_no, :technician, :shipper, :make, :brand, :item_model, :age, :itm_length, :itm_width, :itm_height, :itm_name, :itm_condition)
    end
end
