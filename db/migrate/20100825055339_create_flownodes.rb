class CreateFlownodes < ActiveRecord::Migration
  def self.up
    create_table :flownodes do |t|
      t.string :code
      t.string :name
      t.string :name_cn
      t.string :rec_type
      t.string :status
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :flownodes
  end
end
