class GroupPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if is_admin?
                scope.respond_to?(:all) ? scope.all : scope
            else
                user.groups
            end
        end
    end
    
    def index?
        true
    end

    def show?
        is_admin? or resource_user?
    end

    def create?
        is_admin?
    end

    def update?
        is_admin? or resource_user?
    end
    
    def destroy?
        is_admin? or resource_user?
    end


    # Non-standard Routes
    
    def user_groups_index?
       index? 
    end
end