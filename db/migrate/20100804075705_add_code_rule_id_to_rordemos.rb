class AddCodeRuleIdToRordemos < ActiveRecord::Migration
  def self.up
    add_column :rordemos, :code_rule_id, :integer
  end

  def self.down
    remove_column :rordemos, :code_rule_id
  end
end
