class Teams < ActiveRecord::Migration[6.1]
  def self.up
    create_table :teams do |t|
      t.column :name, :string, :null => false
      t.column :description, :text
    end
  end
  def self.down
    drop_table :teams
  end
end
