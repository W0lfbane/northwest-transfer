module Concerns::Notes::Notable
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        source.class_eval do
            has_many :notes, as: :loggable
            accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
        end
        
        define_instance_methods(source)
    end

    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    def define_instance_methods(source = self)
        source.class_eval do
            # Returns a boolean which evaluates to true if the note count in RAM is greater than in the DB
            def note_added?
                persisted_count = self.notes.count
                ram_count = self.notes.to_a.count
                ram_count > persisted_count
            end
            
            # Validation method
            def note_was_added
                errors.add(:notes, "must be added") unless note_added?
            end
        end
    end

    extend self
end