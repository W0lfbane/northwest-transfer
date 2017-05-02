class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :customer_firstname
      t.string :customer_lastname
      t.string :ems_order_no
      t.string :technician
      t.string :shipper
      t.string :make
      t.string :brand
      t.string :item_model
      t.string :age
      t.string :itm_length
      t.string :itm_height
      t.string :itm_width
      t.string :itm_name
      t.string :itm_condition
      t.belongs_to :documentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
