class AddFieldsToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :customer_firstname, :string
    add_column :documents, :customer_lastname, :string
    add_column :documents, :ems_order_no, :integer
    add_column :documents, :technician, :string
    add_column :documents, :shipper, :string
    add_column :documents, :make, :string
    add_column :documents, :brand, :string
    add_column :documents, :item_model, :string
    add_column :documents, :age, :string
    add_column :documents, :itm_length, :string
    add_column :documents, :itm_height, :string
    add_column :documents, :itm_width, :string
    add_column :documents, :itm_name, :string
    add_column :documents, :itm_condition, :string

  end
end
