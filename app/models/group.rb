class Group < ApplicationRecord
    has_many :group_users, dependent: :destroy
    has_many :users, through: :group_users
    has_many :group_projects, dependent: :destroy
    has_many :projects, through: :group_projects

    resourcify
    
    validates :name, presence: true

    # Ghost Method technique for dynamism in role entries
    def method_missing(method, *args)
        method_name = method.to_s
        role_name = method_name.tr('>>=<< ', '').singularize

        if(self.class_roles.include?(role_name) && method_name[/[a-zA-Z]+/] == method_name)
            User.with_role(role_name, self)
        else
            super
        end
    end

    # Returns and array of existing roles on self
    def class_roles
        Role.where(resource_type: self.class.to_s).pluck(:name).uniq
    end
end
