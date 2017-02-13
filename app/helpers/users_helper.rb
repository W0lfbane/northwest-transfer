module UsersHelper
    def admin_user?
       current_user.has_role?(:admin) 
    end
end
