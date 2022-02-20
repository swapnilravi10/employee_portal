class AddDesignationToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :designation_id, :integer
    add_index :users, :designation_id
  end
end
