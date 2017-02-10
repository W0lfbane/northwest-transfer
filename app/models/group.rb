class Group < ApplicationRecord
    include Helpers::ResourceRolesHelper

    has_many :group_users, dependent: :destroy
    has_many :users, -> { distinct }, through: :group_users
    has_many :group_projects, dependent: :destroy
    has_many :projects, -> { distinct }, through: :group_projects

    resourcify
    
    validates :title, :description, presence: true
end
