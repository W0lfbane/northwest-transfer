class User < ApplicationRecord
  after_create :assign_default_role

  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  protected
  
    def assign_default_role
      self.add_role(:standard) if self.roles.blank?
    end
end
