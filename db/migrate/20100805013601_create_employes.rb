class CreateEmployes < ActiveRecord::Migration
  def self.up
    create_table :employes do |t|
      t.strng :code
      t.string :name
      t.integer :department_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :employes
  end
end
