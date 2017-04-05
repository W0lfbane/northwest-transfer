module Helpers::ResourceStateHelper

    # Helper methods for managing resource states
    def valid_state?(state)
        self.class::STATES.include?(state.to_sym)
    end

    def state_completed?(min_state, max_state = self.aasm.current_state)
        min = self.class::STATES.index(min_state.to_sym)
        max = self.class::STATES.index(max_state.to_sym)
        max >= min
    end

    def current_state?(state)
        self.aasm.current_state == state.to_sym
    end

    def interacting_with_state?(state, max_state = self.aasm.current_state)
        @state = state.to_sym

        if valid_state?(@state)
            current_state?(@state) || state_completed?(@state, max_state)
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

    # Returns a boolean specifying if both the current and previous states are eligible for a transition if a previous state exists
    def valid_transition_with_previous_state?
        if previous_state?
            self.interacting_with_state? self.aasm.current_state, previous_state
        else
            true
        end
    end
    
    # Set previous_state attribute on resource
    def set_previous_state!(state = self.aasm.current_state)
        self.update!(previous_state: state)
    end

end
