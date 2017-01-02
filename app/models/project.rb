class Project < ApplicationRecord
    has_many :project_users, dependent: :destroy
    has_many :users, through: :project_users
    has_many :group_projects, dependent: :destroy
    has_many :groups, through: :group_projects
    has_many :tasks, dependent: :destroy

    resourcify

    validates :title, presence: true, if: :pending?

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
    
        event :complete do
            transitions from: [:in_progress, :problem], to: :completed
        end
    
        event :report_problem do
            transitions to: :problem
        end

        event :deactivate do
            transitions to: :deactivated
        end
    end

    # Ghost Method technique for dynamism in role entries
    def method_missing(method, *args)
        method_name = method.to_s
        role_name = method_name.tr('>>=<< ', '').singularize

        if(self.show_roles.include?(role_name) && method_name[/[a-zA-Z]+/] == method_name)
            User.with_role(role_name, self)
        else
            super
        end
    end

    # Returns and array of existing roles on self
    def show_roles
       self.roles.pluck(:name)
    end
end