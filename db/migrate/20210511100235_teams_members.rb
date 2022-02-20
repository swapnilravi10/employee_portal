class TeamsMembers < ActiveRecord::Migration[6.1]
  def self.up 
    create_table :team_members do |t|
      t.column :user_id, :integer
      t.column :team_id, :integer
      t.column :is_team_leader, :boolean, default: false
    end
  end
  def self.down
    drop_table :team_members
  end
end
