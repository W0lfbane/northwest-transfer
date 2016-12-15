class Task < ApplicationRecord
  include AASM

  aasm do
  end
    belongs_to :project

    include AASM
    
    aasm do
        state :initial, :initial => true
        state :completed
        state :problem
    
        event :complete do
            transitions :from => :initial, :to => :completed
            transitions :from => :problem, :to => :completed
        end
    
        event :report_problem do
            transitions :from => :initial, :to => :problem
        end
    end
end