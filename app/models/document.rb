class Document < ApplicationRecord
    include Helpers::ResourceStateHelper
    belongs_to :project

    validates :title, presence: true
    
    include AASM
    STATES = [:pending, :completed, :deactivated]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end
        
        before_all_events :set_state_user
    
        event :complete do
            transitions to: :completed
        end
    
        event :deactivate!, guards: lambda { @user.admin? } do
            transitions to: :problem
        end
    end
end