class NotesController < Flexible::ApplicationController
  include Concerns::Notes::Nested::SetAuthor

  before_action :authenticate_user!
  before_action :set_author, only: [:create, :update]

  private

    def note_params
      params.require(:note).permit(:text, :user_id)
    end

end
