class UserPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if is_admin
                scope.all
            else
                user
            end
        end
    end

    def index?
        is_admin
    end

    def create?
        is_admin
    end

    def update?
        is_admin or matching_user
    end

    def destroy?
        is_admin or matching_user
    end

    # Policy Helpers
    
    def matching_user
        record.id == user.id
    end
end