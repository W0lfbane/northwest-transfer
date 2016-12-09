class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.belongs_to :project, foreign_key: true, index: true

      t.timestamps
    end
  end
end
