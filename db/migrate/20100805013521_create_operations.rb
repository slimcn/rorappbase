class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.string :code
      t.string :rec_type
      t.string :name
      t.integer :parent_id
      t.string :name_cn
      t.string :url
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end
