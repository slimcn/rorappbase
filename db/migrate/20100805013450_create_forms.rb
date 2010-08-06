class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string :code
      t.string :name
      t.string :name_cn
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :forms
  end
end
