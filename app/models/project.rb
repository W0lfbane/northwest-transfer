class Project < ApplicationRecord
    include Helpers::ResourceRolesHelper
    
    has_many :project_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :project_users
    has_many :group_projects, dependent: :destroy
    has_many :groups, -> { distinct }, through: :group_projects
    has_many :tasks, dependent: :destroy
    has_one :document, dependent: :destroy
    accepts_nested_attributes_for :document

    resourcify

    validates   :title, :description, :address, :city, :state, 
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
    
        event :complete, after: :set_completion_date do
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
       if self.completed? then self.completion_date.to_datetime - self.start_date.to_datetime end
    end
    
    def set_completion_date
       self.update!(completion_date: DateTime.now) 
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
            when 2
              'danger'
            end
        end
    end

end