class CreateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|
      t.belongs_to :user, foreign_key: true, index: true, unique: true
      t.belongs_to :group, foreign_key: true, index: true, unique: true

      t.timestamps
    end
  end
end