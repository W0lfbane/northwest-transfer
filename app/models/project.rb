class Project < ApplicationRecord
    has_many :project_users
    has_many :users, through: :project_users
    
    validates :title, :description, :location, :start_date, :estimated_time, presence: true
    
    def customers
       self.project_users.where(role: 'customer')
    end
    
    def customers=(user)
       self.project_users << user
    end

    def employees
       self.project_users.where(role: 'customer')
    end
    
    def employees=(user)
       self.project_users << user
    end
end
