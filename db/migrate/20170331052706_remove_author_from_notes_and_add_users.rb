class RemoveAuthorFromNotesAndAddUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :logs, :user, foreign_key: true, index: true
    remove_column :logs, :author, :string
  end
end
