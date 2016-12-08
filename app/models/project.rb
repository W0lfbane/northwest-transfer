class Project < ApplicationRecord
    has_many :project_users
    has_many :users, through: :project_users
    
    validates :title, :description, :location, :start_date, :estimated_time, presence: true
end
