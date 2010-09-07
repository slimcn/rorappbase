class CreateFormlogs < ActiveRecord::Migration
  def self.up
    create_table :formlogs do |t|
      t.integer :form_id
      t.string :form_type
      t.string :status
      t.text :content
      t.integer :auditflows_flownode_id
      t.integer :employe_id
      t.integer :user_id
      t.integer :before_sequence_id
      t.integer :after_sequence_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :formlogs
  end
end
