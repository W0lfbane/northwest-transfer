class TasksController < Flexible::ResourceController
  include Concerns::Notes::Nested::SetAuthor
  include Concerns::Resource::State::ResourceStateChange

  before_action :authenticate_user!
  before_action :set_author, only: [:create, :update]

  private

    def task_params
      params.require(:task).permit(:name,
                                    :description,
                                    :resource_state,
                                    notes_attributes: [:id, :text, :user_id, :_destroy])
    end

end
