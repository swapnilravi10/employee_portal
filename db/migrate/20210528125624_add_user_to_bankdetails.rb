class AddUserToBankdetails < ActiveRecord::Migration[6.1]
  def change
    add_column :bankdetails, :user_id, :integer
    add_index :bankdetails, :user_id
  end
end
