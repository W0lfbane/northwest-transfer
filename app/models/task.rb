class Task < ApplicationRecord
    include Helpers::ResourceStateHelper

    belongs_to :project, inverse_of: :tasks
    has_many :notes, as: :loggable
    accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
    
    validates :name, presence: true

    include AASM
    STATES = [:pending, :completed, :problem]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end
    
        event :complete do
            transitions to: :completed
        end
    
        event :report_problem, guard: :note_added? do
            transitions to: :problem
        end
    end
    
    def note_added?
        task = self
        persisted_count = task.notes.count
        ram_count = task.notes.to_a.count
        
        ram_count > persisted_count
    end
    
    def note_added
        errors.add(:notes, "must be added") unless note_added?
    end
    
end