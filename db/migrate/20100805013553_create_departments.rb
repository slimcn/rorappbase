class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :code
      t.string :name
      t.string :parent_code
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
