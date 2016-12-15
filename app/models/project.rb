class Project < ApplicationRecord
  include AASM

  aasm do
  end
    has_many :project_users
    has_many :users, through: :project_users
    has_many :group_projects
    has_many :groups, through: :group_projects
    has_many :tasks, dependent: :destroy
    
    resourcify
    
    validates :title, :description, :location, :start_date, :estimated_time, presence: true

    # Ghost Method technique for dynamism in role entries
    def method_missing(method, *args)
        method_name = method.to_s
        role_name = method_name.tr('>>=<< ', '').singularize

        if(self.show_roles.include?(role_name) && method_name[/[a-zA-Z]+/] == method_name)
            User.with_role(role_name, self)
        else
            super
        end
    end

    # Returns and array of existing roles on self
    def show_roles()
       self.roles.map { |role| role.name }
    end

end
