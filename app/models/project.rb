class Project < ApplicationRecord
    has_many :project_users
    has_many :users, through: :project_users
    has_many :group_projects
    has_many :groups, through: :group_projects
    has_many :tasks, dependent: :destroy
    
    resourcify
    
    validates :title, :description, :location, :start_date, :estimated_time, presence: true
    
    include AASM
    aasm :column => 'resource_state' do
        state :initial, initial: true
        state :en_route
        state :in_progress
        state :completed
        state :problem
        
        event :start_route do 
            transitions from: :initial, to: :en_route
            transitions from: :problem, to: :en_route
        end
        
        event :start_working do
            transitions from: :en_route, to: :in_progress
            transitions from: :problem, to: :in_progress
        end
    
        event :complete do
            transitions from: :in_progress, to: :completed
            transitions from: :problem, to: :completed
        end
    
        event :report_problem do
            transitions from: :initial, to: :problem
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
    def show_roles()
       self.roles.map { |role| role.name }
    end

end
