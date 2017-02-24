class UserPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if is_admin?
                scope.respond_to?(:all) ? scope.all : scope
            end
        end
    end

    def index?
        is_admin?
    end

    def show?
        is_admin? or matching_user?
    end

    def create?
        is_admin?
    end
    
    def update?
        is_admin? or matching_user?
    end

    # Policy Helpers
    
    def matching_user?
        record.id == user.id
    end
end