class TaskPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            scope.all
        end
    end
    
    def index?
        true
    end

    def show?
        true
    end

    def create?
        is_admin?
    end

    def update?
        true
    end
    
    def destroy?
        is_admin?
    end
end