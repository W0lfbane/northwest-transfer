class CreateResourceFields < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_fields do |t|
      t.string :data_key
      t.string :data_value
      t.belongs_to :fieldable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
