class RemoveAddColumnDesignationInUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :designation_id if column_exists? :users, :designation_id
    add_column :users, :designation_id, :integer, foreign_key: true, null: true unless column_exists? :users, :designation_id
  end
end
