class Flexible::ApplicationController < ApplicationController
  include Concerns::Resource::Nested::SetResource

  before_action :authenticate_user!
  before_action :set_resource
  before_action :set_document, except: [:index, :create]
  before_action :authorize_document, except: [:index, :create]

  def index
    @resource.class == Document ? @documents = policy_scope(Document) : @documents = policy_scope(@resource.documents)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @document = @resource.class == Document ? @resource : @resource.documents.build(document_params)
    authorize_document

    respond_to do |format|
      if @document.save
        format.html { redirect_to helpers.flexible_resource_path(:document_path, @document), notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: helpers.flexible_resource_path(:document_path, @document) }
      else
        format.html { render :new }
        format.json { render json: { errors: @document.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to helpers.flexible_resource_path(:document_path, @document), notice: 'document was successfully updated.' }
        format.json { render :show, status: :ok, location: helpers.flexible_resource_path(:document_path, @document) }
      else
        format.html { render :edit }
        format.json { render json: { errors: @document.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to @resource, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_document
      if @resource.class == Document
        @document = @resource
      else
        @document = params[:id] ? @resource.documents.find(params[:id]) : @resource.documents.build
      end
    end

    def authorize_document
      authorize @document
    end

    def document_params
      params.require(:document).permit(:title,
                                        :signature, 
                                        :resource_state, 
                                        :completion_date, 
                                        :customer_firstname, 
                                        :customer_lastname, 
                                        :ems_order_no, 
                                        :technician, 
                                        :shipper, 
                                        :make, 
                                        :brand, 
                                        :itm_model, 
                                        :age, 
                                        :itm_length, 
                                        :itm_width, 
                                        :itm_height, 
                                        :itm_name, 
                                        :itm_condition)
    end
end
