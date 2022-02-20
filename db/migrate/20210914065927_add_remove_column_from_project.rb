class AddRemoveColumnFromProject < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :team_id if column_exists? :projects, :team_id
    add_column :projects, :project_leader_id, :integer, index: true, foreign_key: true
  end
end