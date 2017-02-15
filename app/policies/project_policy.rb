class ProjectPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if is_admin?
                scope.all
            else
                user.projects
            end
        end
    end
    
    def index?
        true
    end

    def schedule_index?
        index? 
    end

    def user_projects_index?
        index? 
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
end