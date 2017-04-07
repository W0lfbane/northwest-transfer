module Helpers::ResourceStateHelper

    # Helper methods for managing resource states
    def valid_state?(state)
        self.class::STATES.include?(state.to_sym)
    end

    def state_completed?(min_state, max_state = self.aasm.current_state)
        min = self.class::STATES.index(min_state.to_sym)
        max = self.class::STATES.index(max_state.to_sym)
        max > min
    end

    def current_state?(state, current_state = self.aasm.current_state)
        current_state == state.to_sym
    end

    def interacting_with_state?(state, current_state = self.aasm.current_state)
        if valid_state?(state) && valid_state?(current_state)
            current_state?(state, current_state) || state_completed?(state, current_state)
        else
            raise ArgumentError, "The state passed is invalid"
        end
    end

    def set_state_user(user = User.new)
       @user = user
    end

    # Figure out a good way to test for state transitions
    def transitioning_to_problem_state?
        resource_state == 'problem'
    end

    # Returns a boolean specifying if the previous state is eligible for the requested transition if a previous_state exists
    def valid_transition_with_previous_state?
        if previous_state?
            obj_copy = self.dup
            obj_copy.resource_state = previous_state
            obj_copy.previous_state = nil
            event = aasm.current_event.to_s.tr('!', '').to_sym

            if interacting_with_state?(aasm.to_state, previous_state)
                true
            else
                obj_copy.aasm.may_fire_event?(event)
            end unless previous_state == aasm.to_state
        else
            true
        end
    end
    
    # Set previous_state attribute on resource
    def set_previous_state!(state = self.aasm.from_state)
        self.update!(previous_state: state) unless state.nil?
    end

end
