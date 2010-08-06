class CreateDepartmentmanagers < ActiveRecord::Migration
  def self.up
    create_table :departmentmanagers do |t|
      t.integer :department_id
      t.integer :employe_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :departmentmanagers
  end
end
