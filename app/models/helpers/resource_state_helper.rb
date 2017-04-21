module Helpers::ResourceStateHelper

    def fetch_events(object = self)
       object.aasm.events.map(&:name)
    end


    def states_list(klass = self.class)
      klass::STATES
    end

    def fetch_events(object = self)
      object.assm.events.map(&:name)
    end

    # Helper methods for managing resource states
    def valid_state?(state = :'')
        states_list.include?(state.to_sym)
    end

    def state_completed?(min_state, max_state = self.aasm.current_state)
        min = states_list.index(min_state.to_sym)
        max = states_list.index(max_state.to_sym)
        max > min
    end

    def current_state?(state, current_state = self.aasm.current_state)
        current_state == state.to_sym
    end

    def interacting_with_state?(state, current_state = self.aasm.current_state)
        raise ArgumentError, "The state passed is invalid" unless valid_state?(state) && valid_state?(current_state)
        current_state?(state, current_state) || state_completed?(state, current_state)
    end

    def set_state_user(user = User.new)
        raise ArgumentError, "The user passed is invalid" unless user.class == User
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
