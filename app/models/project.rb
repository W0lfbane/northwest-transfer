class Project < ApplicationRecord
    include Roles::RoleUsers
    include Concerns::Notes::Notable
    include Concerns::Tasks::Taskable
    include Concerns::Documents::Documentable
    include Helpers::ResourceStateHelper
    include Helpers::ResourceRecordHelper

    has_many :project_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :project_users
    has_many :group_projects, dependent: :destroy
    has_many :groups, -> { distinct }, through: :group_projects
    accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true

    # This is temporary, waiting to think of a better solution. Do not test.
    def users_attributes=(users_attributes)
        users_attributes.each do |key, user_attributes|
            user_hash = users_attributes[key]

            if user_hash[:id].present?
                user = User.find(user_hash[:id])
                if user_hash[:_destroy] == "1"
                    users.delete(user)
                    next
                else
                    users << user unless users.include? user
                end
            else
                super
            end
        end
    end

    validates_associated :tasks, :documents, :users
    validate :note_added, if: lambda { transitioning_to_state?(:problem) }

    resourcify

    validates   :title, :address, :city, :state,
                :postal, :country, :start_date, :estimated_completion_date, presence: true

    include AASM
    STATES = [:pending, :en_route, :in_progress, :pending_review, :completed, :problem, :deactivated]
    aasm :column => 'resource_state', :with_klass => NorthwestTransferAASMBase do
        require_state_methods!
        require_state_events!

        STATES.each do |status|
            state(status, initial: STATES[0] == status, before_enter: :set_previous_state!)
        end

        before_all_events :set_state_user

        event :begin_route, guards: :valid_transition_with_previous_state? do
            transitions from: [:pending, :problem], to: :en_route
        end

        event :begin_working, guards: :valid_transition_with_previous_state? do
            transitions from: [:en_route, :problem], to: :in_progress
        end

        event :request_review, guards: [:no_pending_tasks?, :documents_complete?, :valid_transition_with_previous_state?] do
            transitions from: [:in_progress, :problem], to: :pending_review
        end

        event :complete, guards: [lambda { @user.admin? }, :no_pending_tasks?, :documents_complete?, :valid_transition_with_previous_state?] do
            transitions from: [:pending_review], to: :completed, success: :set_completion_date!
        end

        event :report_problem, guards: :note_added? do
            transitions from: STATES, to: :problem
        end

        event :deactivate, guards: lambda { @user.admin? } do
            transitions from: STATES, to: :deactivated
        end
    end

    def tasks_pending?
        0 != self.tasks.where(resource_state: "pending").count
    end

    def no_pending_tasks?
       !tasks_pending?
    end

    def documents_complete?(object = self)
        if object.respond_to? :documents
            return object.documents.all? { |doc| doc.completed? }
        else
            raise ArgumentError.new("Argument does not have documents!")
        end
    end

    def total_time
       TimeDifference.between(self.start_date.to_datetime, self.completion_date.to_datetime).in_hours
    end

    def set_completion_date!(date = DateTime.now)
       self.update!(completion_date: date)
    end

    def flags
       @flags ||= self.tasks.where(resource_state: 'problem')
    end

    def alert_level
        if self.pending?
            'inactive'
        else
            case self.flags.count
            when 0
              'operational'
            when 1
              'advisory'
            else
              'danger'
            end
        end
    end

    def location
        self.address + ' ' +
        self.city + ' ' +
        self.state + ' ' +
        self.postal + ' ' +
        self.country
    end
end
