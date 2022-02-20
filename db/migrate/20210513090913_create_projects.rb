class CreateProjects < ActiveRecord::Migration[6.1]
  def self.up
    create_table :projects do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :team_id, :integer
      t.column :client_id, :integer
    end
  end
  def self.down
    drop_table :projects
  end
end
