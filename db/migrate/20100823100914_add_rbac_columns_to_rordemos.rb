class AddRbacColumnsToRordemos < ActiveRecord::Migration
  def self.up
    add_column :rordemos, :employe_id, :integer
    add_column :rordemos, :department_id, :integer
  end

  def self.down
    remove_column :rordemos, :employe_id
    remove_column :rordemos, :department_id
  end
end
