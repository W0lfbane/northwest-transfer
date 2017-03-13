class Project < ApplicationRecord
    include Roles::RoleUsers
    include Helpers::ResourceStateHelper
    include Helpers::ResourceRecordHelper
    
    has_many :project_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :project_users
    has_many :group_projects, dependent: :destroy
    has_many :groups, -> { distinct }, through: :group_projects
    has_many :tasks, dependent: :destroy, inverse_of: :project
    has_many :notes, as: :logable
    has_one :document, dependent: :destroy
    accepts_nested_attributes_for :document, :tasks, reject_if: :all_blank, allow_destroy: true
    
    validates_associated :tasks, :document

    resourcify

    validates   :title, :address, :city, :state, 
                :postal, :country, :start_date, :estimated_completion_date, presence: true

    include AASM
    STATES = [:pending, :en_route, :in_progress, :completed, :problem, :deactivated]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end

        event :begin_route do
            transitions from: [:pending, :problem], to: :en_route
        end
        
        event :begin_working do
            transitions from: [:en_route, :problem], to: :in_progress
        end
    
        event :complete, success: :set_completion_date! do
            transitions from: [:in_progress, :problem], to: :completed
        end
    
        event :report_problem do
            transitions to: :problem
        end

        event :deactivate do
            transitions to: :deactivated
        end
    end
    
    def total_time
       if self.completed? then TimeDifference.between(self.start_date.to_datetime, self.completion_date.to_datetime).in_hours end
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
              'operatonal'
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