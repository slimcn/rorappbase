class CreateSelfmenus < ActiveRecord::Migration
  def self.up
    create_table :selfmenus do |t|
      t.string :code
      t.string :name
      t.integer :parent_id
      t.string :rec_type
      t.integer :user_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :selfmenus
  end
end
