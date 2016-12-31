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

    def show?
        is_admin? or project_user?
    end

    def create?
        true
    end

    def update?
        is_admin? or project_user?
    end
    
    def destroy?
        is_admin? or project_user?
    end
    
    # Policy Helpers

    def project_user?
      record.users.include?(user)
    end
end