class NotesController < ApplicationController
  include Concerns::Notes::Nested::SetAuthor
  include Concerns::Resource::Nested::SetParentResource

  before_action :authenticate_user!
  before_action :set_parent_resource
  before_action :set_author, only: [:create, :update]
  before_action :set_note, except: [:index, :create]
  before_action :authorize_note, except: [:index, :create]

  # GET /notes
  # GET /notes.json
  def index
    @notes = policy_scope(@parent_resource.notes)
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = @parent_resource.notes.build(note_params)
    authorize_note

    respond_to do |format|
      if @note.save
        format.html { redirect_to nested_note_path(id: @note), notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: nested_note_path(id: @note) }
      else
        format.html { render :new }
        format.json { render json: { errors: @note.errors }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to nested_note_path(id: @note), notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: nested_note_path(id: @note) }
      else
        format.html { render :edit }
        format.json { render json: { errors: @note.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to @parent_resource, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_note
      @note = params[:id] ? @parent_resource.notes.find(params[:id]) : @parent_resource.notes.build
    end

    def authorize_note
      authorize @note
    end

    def note_params
      params.require(:note).permit(:text, :user_id)
    end

end
