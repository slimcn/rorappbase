class CreateMenutrees < ActiveRecord::Migration
  def self.up
    create_table :menutrees do |t|
      t.string :code
      t.string :name
      t.integer :parent_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :menutrees
  end
end
