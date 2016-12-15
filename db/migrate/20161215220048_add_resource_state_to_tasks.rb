class AddResourceStateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :resource_state, :string
  end
end
