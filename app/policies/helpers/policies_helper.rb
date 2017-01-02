module Helpers::PoliciesHelper
  def is_admin?(user = self.user)
    user.has_role?(:admin)
  end
end