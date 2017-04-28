module Helpers::ResourceStateHelper

    def fetch_events(object = self)
       object.aasm.events.map(&:name)
    end
  
    # Helper methods for managing resource states
    def state_completed?(state, current_state = self.aasm.current_state)
        compute_state_operation(state, :<, current_state)
    end

    def current_state?(state, current_state = self.aasm.current_state)
        compute_state_operation(state, :==, current_state)
    end

    def interacting_with_state?(state, current_state = self.aasm.current_state)
        raise ArgumentError, "The state passed is invalid" unless valid_state?(state) && valid_state?(current_state)
        compute_state_operation(state, :<=, current_state)
    end

    # Figure out a good way to test for state transitions
    def transitioning_to_state?(state)
        compute_state_operation(resource_state, :==, state)
    end
    
    # 1, 2, 3, 4, 5
    
    # previous, current -> eligible
    # nil, 5 -> 6
    # 2, 5 -> 3
    # nil, 1 -> 2
    # 5, 1 -> 2
    # nil, 2 -> 3
    # 1, 2 -> 3
    
    
    # broken
    # 1, 2 -> 3
    

    # Returns a boolean specifying if the previous state is eligible for the requested transition if a previous_state exists
    # Broken but usable
    def valid_transition_with_previous_state?(to_state = nil, previous_state = nil)
        to_state ||= self.aasm.to_state
        previous_state ||= self.previous_state
        
        if previous_state.present?
            blacklist_states = [:problem, :deactivated]
            previous_state_transition_list = Array.new
            to_state_transition_list = Array.new
            ObjectSpace.each_object(AASM::Core::Transition) do |transition|
                previous_state_transition_list << transition if transition.from == previous_state.to_sym
                to_state_transition_list << transition if transition.to == to_state
            end
            
            return true if to_state_transition_list.map(&:from).include? previous_state.to_sym

            vector_state_list = (previous_state_transition_list.map(&:to) & to_state_transition_list.map(&:from)) - blacklist_states
            vector_transition_list = previous_state_transition_list.select { |transition| vector_state_list.include?(transition.to) }
            vector_event_list = vector_transition_list.map(&:event).map(&:name).uniq

            obj_copy = self.dup
            obj_copy.resource_state = previous_state
            obj_copy.previous_state = nil
            vector_event_list.any? { |event| obj_copy.aasm.may_fire_event?(event) }
        else
            true
        end
    end


    # Low-level methods
    
    protected

        def states_list(klass = self.class)
          klass::STATES
        end
    
        def valid_state?(state = :'')
            states_list.include?(state.to_sym)
        end
        
        def get_state_index(state)
            states_list.index(state.to_sym)
        end


    private

        def compute_state_operation(left_state, operator, right_state)
            left_operand = get_state_index(left_state)
            right_operand = get_state_index(right_state)
            left_operand.send(operator, right_operand)
        end

end
