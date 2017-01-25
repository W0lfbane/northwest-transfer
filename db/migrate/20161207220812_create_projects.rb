class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title,                        null: false
      t.text :description,                    null: false
      t.text :address,                        null: false
      t.text :city,                           null: false
      t.text :state,                          null: false
      t.text :postal,                         null: false
      t.text :country,                        null: false, default: 'US'
      t.datetime :start_date,                 null: false
      t.datetime :completion_date
      t.datetime :estimated_completion_date,  null: false
      t.text :notes
      

      t.timestamps
    end
  end
end
