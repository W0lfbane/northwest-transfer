class User < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  before_create :assign_default_role

  rolify strict: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  protected
  
    def assign_default_role
      self.add_role(:customer) if self.roles.blank?
    end
end
