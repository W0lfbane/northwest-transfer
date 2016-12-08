class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  
  def customers_empty
    self.project.customers.empty?
  end
end
