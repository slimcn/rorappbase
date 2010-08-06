class CreateEmployesUsers < ActiveRecord::Migration
  def self.up
    create_table :employes_users do |t|
      t.integer :user_id
      t.integer :employe_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :employes_users
  end
end
