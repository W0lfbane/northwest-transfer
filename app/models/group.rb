class Group < ApplicationRecord
    include Roles::RoleUsers
    include Helpers::ResourceStateHelper

    has_many :group_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :group_users
    has_many :group_projects, dependent: :destroy
    has_many :projects, -> { distinct }, through: :group_projects

    resourcify
    
    validates :name, presence: true
    
    include AASM
    STATES = [:activated, :deactivated]
    aasm :column => 'resource_state', :with_klass => NorthwestTransferAASMBase do
      require_state_methods!

      STATES.map do |status|
        state(status, initial: STATES[0] == status)
      end

      before_all_events :set_state_user
      
      event :deactivate, guards: lambda { @user.admin? }  do
        transitions to: :deactivated
      end
    end
end
