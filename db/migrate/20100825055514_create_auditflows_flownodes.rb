class CreateAuditflowsFlownodes < ActiveRecord::Migration
  def self.up
    create_table :auditflows_flownodes do |t|
      t.integer :auditflow_id
      t.integer :flownode_id
      t.string :sequence
      t.string :name
      t.integer :role_id
      t.string :rec_type
      t.string :status
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :auditflows_flownodes
  end
end
