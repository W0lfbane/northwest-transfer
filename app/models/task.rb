class Task < ApplicationRecord
    belongs_to :project

    include AASM
    aasm :column => 'resource_state' do
        state :pending, initial: true
        state :completed
        state :problem
    
        event :complete do
            transitions to: :completed
        end
    
        event :report_problem do
            transitions to: :problem
        end
    end
end