module ResourceStatesHelper
    def filter_states(klass, admin_only_states)
       states = klass::STATES.clone

       unless current_user.admin?
        admin_only_states.to_a.each { |state| states.delete(state) }
       end
       
       return states
    end
end
