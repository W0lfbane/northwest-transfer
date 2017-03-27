class RemoveNotesFromTasksAndProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :notes, :string
    remove_column :projects, :notes, :string
  end
end
