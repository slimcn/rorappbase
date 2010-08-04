class CreateCodeRules < ActiveRecord::Migration
  def self.up
    create_table :code_rules do |t|
      t.string :table_name
      t.string :field_name
      t.string :title
      t.integer :seq
      t.integer :seq_len
      t.integer :step
      t.string :rule_type
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :code_rules
  end
end
