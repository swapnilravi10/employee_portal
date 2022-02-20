class AddAssignedToToDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :assigned_to, :integer, if_not_exists: true
  end
end
