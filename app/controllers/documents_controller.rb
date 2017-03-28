class DocumentsController < ApplicationController
  include Resource::State::ResourceStateChange
  
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_document, except: [:create]
  before_action :authorize_document, except: [:create]

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
    @document = @project.build_document(document_params)
    authorize_document

    respond_to do |format|
      if @document.save
        format.html { redirect_to project_document_url(@project), notice: 'document was successfully created.' }
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
        format.html { redirect_to project_document_url(@project), notice: 'document was successfully updated.' }
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
      @project = Project.find(params[:project_id])
    end

    def set_document
      @document = @project.document.nil? ? @project.build_document : @project.document 
    end
    
    def authorize_document
      authorize @document
    end
  
    def document_params
      params.require(:document).permit(:title, :signature, :resource_state, :completion_date)
    end
end
