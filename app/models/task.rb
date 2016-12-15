class Task < ApplicationRecord
    belongs_to :project

    include AASM
    aasm :column => 'resource_state' do
        state :initial, initial: true
        state :completed
        state :problem
    
        event :complete do
            transitions from: :initial, to: :completed
            transitions from: :problem, to: :completed
        end
    
        event :report_problem do
            transitions from: :initial, to: :problem
        end
    end
end