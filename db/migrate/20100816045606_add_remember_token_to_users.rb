class AddRememberTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_token, :string, :limit => 40
  end

  def self.down
  end
end
