class AddCodeToEmployes < ActiveRecord::Migration
  def self.up
    add_column :employes, :code, :string
  end

  def self.down
    remove_column :employes, :code
  end
end
