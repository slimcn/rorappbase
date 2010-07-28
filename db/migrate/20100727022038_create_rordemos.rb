class CreateRordemos < ActiveRecord::Migration
  def self.up
    create_table :rordemos do |t|
      t.string :code
      t.string :name
      t.integer :recordtype
      t.string :status
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :rordemos
  end
end
