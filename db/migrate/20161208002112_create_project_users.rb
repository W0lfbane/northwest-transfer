class CreateProjectUsers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :project, :users do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :project, foreign_key: true
      t.boolean :customer
    end
  end
end
