class Task < ApplicationRecord
    include Helpers::ResourceStateHelper

    belongs_to :project, inverse_of: :tasks
    has_many :notes, as: :loggable
    
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
    
        event :report_problem, :error => :no_note do
            transitions to: :problem, :after => Proc.new {|*args| add_note(*args) }
        end
    end
    
    def add_note(text, author)
        self.notes << Note.new(author: author.to_s, text: text.to_s)
        self.save
    end
    
    #note: if we don't want the error to do anything special we may as well take this out and remove the :error => :no_note above
    def no_note(error)
        if error.class == ArgumentError 
            p "You need to pass in the note >:|"
        else
            raise error
        end
    end
end