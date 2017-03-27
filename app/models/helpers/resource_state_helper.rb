module Helpers::ResourceStateHelper

    # Helper methods for managing resource states
    def valid_state?(state)
        self.class::STATES.include?(state.to_sym)
    end

    def state_completed?(state)
        min = self.class::STATES.index(state.to_sym)
        max = self.class::STATES.index(self.aasm.current_state)
        max > min
    end

    def current_state?(state)
        if self.aasm.current_state == state.to_sym
           true
        end
    end

    def interacting_with_state?(state)
        @state = state.to_sym

        if valid_state?(@state)
            current_state?(@state) || state_completed?(@state)
        else
            false
        end
    end

    def set_state_user(user = User.new)
       @user = user
    end

    # Figure out a good way to test for state transitions
    def transitioning_to_problem_state?
        resource_state == 'problem'
    end
end
