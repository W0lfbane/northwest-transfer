class AddResourceStateToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :resource_state, :string
  end
end
