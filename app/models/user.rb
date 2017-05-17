class User < ApplicationRecord
  include Concerns::Roles::RoleModification
  Roles::Helper.invoke(self)

  ROLES = [:customer, :employee, :admin]

  has_many :project_users, dependent: :destroy
  has_many :projects, -> { distinct }, through: :project_users
  has_many :group_users, dependent: :destroy
  has_many :groups, -> { distinct }, through: :group_users
  has_many :notes

  before_create :assign_default_role

  rolify strict: true

  # Devise has default validations for it's attributes, only validate ones specific to this application
  validates :first_name, :last_name, :phone, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def name
    self.first_name.to_s.capitalize + ' ' + self.last_name.to_s.capitalize
  end

  def admin?
    self.has_role?(:admin)
  end

  # For nested user routes
  def find_resource
     nil
  end
  
  protected

    def assign_default_role
      self.add_role(:customer) if self.roles.blank?
    end

end
