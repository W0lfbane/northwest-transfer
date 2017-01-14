class CreateGroupProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :group_projects do |t|
      t.belongs_to :group, foreign_key: true, index: true, unique: true
      t.belongs_to :project, foreign_key: true, index: true, unique: true

      t.timestamps
    end
  end
end
