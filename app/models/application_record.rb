class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def state_completed?(state)
        min = self.class::STATES.index(state)
        max = self.class::STATES.index(self.aasm.current_state)
        max > min
    end

    def current_state?(state)
        if self.aasm.current_state == state
           true 
        end
    end
    
    def interacting_with_state?(state)
        current_state?(state) || state_completed?(state) 
    end
end
