class RemoveDesignationIdFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :designation_id, :integer
  end
end
