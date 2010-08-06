class CreateFormsSelfmenus < ActiveRecord::Migration
  def self.up
    create_table :forms_selfmenus do |t|
      t.integer :selfmenu_id
      t.integer :form_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :forms_selfmenus
  end
end
