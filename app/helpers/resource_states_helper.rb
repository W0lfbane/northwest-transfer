module ResourceStatesHelper
    # Returns an internationalized key => value paired collection of states defined on the model
    def resource_states(klass)
       states = klass::STATES.clone
       parsed_states = states.map { |n| I18n.t(n).capitalize }
       paired_state_hash = Hash[parsed_states.zip(states)]

       return paired_state_hash
    end
end
