class Project < ApplicationRecord
    has_many :project_users
    has_many :users, through: :project_users
    has_many :group_projects
    has_many :groups, through: :group_projects
    has_many :tasks, dependent: :destroy
    
    validates :title, :description, :location, :start_date, :estimated_time, presence: true
    
    def method_missing(method, *args)
        
        puts method
        
    end
    
    def customers
       self.project_users.where(role: 'customer')
    end
    
    def customers=(user)
       ProjectUser.create(user_id: user.id, project_id: self.id, role: 'customer')
    end

    def employees
       self.project_users.where(role: 'employee')
    end
    
    def employees=(user)
       self.project_users << user
    end
end
