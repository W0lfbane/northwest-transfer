class GroupPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if is_admin?
                scope.all
            else
                user.groups
            end
        end
    end

    def show?
        is_admin? or group_user?
    end

    def create?
        true
    end

    def update?
        is_admin? or group_user?
    end
    
    def destroy?
        is_admin? or group_user?
    end
    
    # Policy Helpers

    def group_user?
      record.users.include?(user)
    end
end