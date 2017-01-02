class Task < ApplicationRecord
    belongs_to :project

    include AASM
    STATES = [:pending, :completed, :problem]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end
    
        event :complete do
            transitions to: :completed
        end
    
        event :report_problem do
            transitions to: :problem
        end
    end
end