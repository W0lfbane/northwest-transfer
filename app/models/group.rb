class Group < ApplicationRecord
    include Helpers::ResourceRolesHelper

    has_many :group_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :group_users
    has_many :group_projects, dependent: :destroy
    has_many :projects, -> { distinct }, through: :group_projects

    resourcify
    
    validates :name, presence: true
    
    include AASM
    STATES = [:activated, :deactivated]
    aasm :column => 'resource_state' do
      STATES.each do |status|
          state(status, initial: STATES[0] == status)
      end
      
      event :deactivate do
        transitions to: :deactivated
      end
    end
end
