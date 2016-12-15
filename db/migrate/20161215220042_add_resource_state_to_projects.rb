class AddResourceStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :resource_state, :string
  end
end
