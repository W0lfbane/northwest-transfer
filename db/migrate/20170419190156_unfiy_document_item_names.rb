class UnfiyDocumentItemNames < ActiveRecord::Migration[5.0]
  def change
    remove_column :documents, :item_model
    add_column :documents, :itm_model, :string
  end
end
