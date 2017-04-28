class NorthwestTransferAASMBase < AASM::Base
    # A custom annotation that we want available across many AASM models.
    def require_state_methods!
        klass.class_eval do
            # Allows for passing User to state event method
            def set_state_user(user = User.new)
                raise ArgumentError, "The user passed is invalid" unless user.class == User
                @user = user
            end

            # Set previous_state attribute on resource
            def set_previous_state!(state = self.aasm.from_state)
                self.update!(previous_state: state) unless state.nil?
            end
        end
    end
    
    def require_state_events!
        klass.class_eval do
            aasm :column => 'resource_state', :with_klass => NorthwestTransferAASMBase do
                if Rails.env.development?
                    event :reset, success: lambda { set_previous_state!(:pending) } do
                        transitions to: :pending
                    end
                end
            end
        end
    end

end