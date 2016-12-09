class CreateProjectUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :project_users do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :project, foreign_key: true, index: true

      t.timestamps
    end
  end
end
