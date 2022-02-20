class CreateProjectTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :project_teams do |t|
      t.references :user, foreign_key: true, index: true
      t.references :project, foreign_key: true, index: true
      t.string :designation
      t.string :project_profile

      t.timestamps
    end
  end
end
