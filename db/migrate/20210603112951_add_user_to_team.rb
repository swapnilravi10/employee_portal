class AddUserToTeam < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :project_manager_id, :integer
    add_index :teams, :project_manager_id
  end
end
