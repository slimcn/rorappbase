class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :code
      t.string :name
      t.string :rec_type
      t.integer :form_id
      t.string :name_cn
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end
