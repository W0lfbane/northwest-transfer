class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title,            null: false
      t.text :description
      t.string :location
      t.datetime :start_date
      t.datetime :completion_date
      t.time :estimated_time
      t.time :total_time
      t.text :notes

      t.timestamps
    end
  end
end
