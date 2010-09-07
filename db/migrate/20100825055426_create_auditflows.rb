class CreateAuditflows < ActiveRecord::Migration
  def self.up
    create_table :auditflows do |t|
      t.string :code
      t.string :name
      t.string :name_cn
      t.text :condition
      t.string :rec_type
      t.string :status
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :auditflows
  end
end
