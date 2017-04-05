class Project < ApplicationRecord
    include Roles::RoleUsers
    include Notes::Notable
    include Helpers::ResourceStateHelper
    include Helpers::ResourceRecordHelper

    has_many :project_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :project_users
    has_many :group_projects, dependent: :destroy
    has_many :groups, -> { distinct }, through: :group_projects
    has_many :tasks, dependent: :destroy, inverse_of: :project
    has_one :document, dependent: :destroy
    accepts_nested_attributes_for :document, :tasks, :users, reject_if: :all_blank, allow_destroy: true

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

    validates_associated :tasks, :document, :users
    validate :note_added, if: :transitioning_to_problem_state?

    resourcify

    validates   :title, :address, :city, :state,
                :postal, :country, :start_date, :estimated_completion_date, presence: true

    include AASM
    STATES = [:pending, :en_route, :in_progress, :pending_review, :completed, :problem, :deactivated]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end

        before_all_events :set_state_user, :set_previous_state!

        event :begin_route do
            transitions from: [:pending, :problem], to: :en_route, guard: :valid_transition_with_previous_state?
        end

        event :begin_working do
            transitions from: [:en_route, :problem], to: :in_progress, guard: :valid_transition_with_previous_state?
        end

        event :request_review, guards: [:no_pending_tasks?, :document_complete?] do
            transitions from: [:in_progress, :problem], to: :pending_review, guard: :valid_transition_with_previous_state?
        end

        event :complete, success: :set_completion_date!, guards: [lambda { @user.admin? }, :no_pending_tasks?, :document_complete?] do
            transitions from: [:pending_review], to: :completed, guard: :valid_transition_with_previous_state?
        end

        event :report_problem do
            transitions to: :problem
        end

        event :deactivate, guards: lambda { @user.admin? } do
            transitions to: :deactivated
        end
    end

    def tasks_pending?
        0 != self.tasks.where(resource_state: "pending").count
    end
    
    def no_pending_tasks?
       !tasks_pending?
    end

    def document_complete?
        if self.document.nil?
            return false
        else
            self.document.completed?
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
