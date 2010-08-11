class AddIncodeToDepartments < ActiveRecord::Migration
  def self.up
    remove_column :departments, :parent_code
    add_column :departments, :parent_id, :integer
    add_column :departments, :incode, :string
  end

  def self.down
    add_column :departments, :parent_code, :string
    remove_column :departments, :parent_id
    remove_column :departments, :incode
  end
end
