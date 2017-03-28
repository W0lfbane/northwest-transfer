class AddColumnsToDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :signature, :string
    add_column :documents, :completion_date, :datetime
    add_column :documents, :resource_state, :string
  end
end
