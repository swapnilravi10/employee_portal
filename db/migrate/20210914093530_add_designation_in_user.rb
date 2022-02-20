class AddDesignationInUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :designation_id, :integer, if_not_exists: true
  end
end
