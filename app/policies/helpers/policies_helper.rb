module Helpers::PoliciesHelper
  def is_admin?(user = self.user)
    user.has_role?(:admin)
  end
  
  def resource_user?
    record.users.include?(user)
  end
  
end