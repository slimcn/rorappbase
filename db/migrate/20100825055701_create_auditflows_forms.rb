class CreateAuditflowsForms < ActiveRecord::Migration
  def self.up
    create_table :auditflows_forms do |t|
      t.integer :form_id
      t.integer :auditflow_id
      t.string :form_type
      t.integer :auditflows_flownode_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :auditflows_forms
  end
end
