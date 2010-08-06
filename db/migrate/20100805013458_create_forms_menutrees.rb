class CreateFormsMenutrees < ActiveRecord::Migration
  def self.up
    create_table :forms_menutrees do |t|
      t.integer :menutree_id
      t.integer :form_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :forms_menutrees
  end
end
