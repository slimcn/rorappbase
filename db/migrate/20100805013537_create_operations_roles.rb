class CreateOperationsRoles < ActiveRecord::Migration
  def self.up
    create_table :operations_roles do |t|
      t.integer :role_id
      t.integer :operation_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :operations_roles
  end
end
