class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.belongs_to :logable, polymorphic: true, index: true
      t.string :text
      t.string :type
      t.string :author

      t.timestamps
    end
  end
end
