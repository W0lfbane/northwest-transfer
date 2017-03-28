class Task < ApplicationRecord
    include Helpers::ResourceStateHelper
    include Notes::Notable

    belongs_to :project, inverse_of: :tasks

    validates :name, presence: true
    validate :note_added, if: :transitioning_to_problem_state?

    include AASM
    STATES = [:pending, :completed, :problem]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end

        event :complete do
            transitions to: :completed
        end

        event :report_problem, guards: :note_added? do
            transitions to: :problem
        end
    end

end