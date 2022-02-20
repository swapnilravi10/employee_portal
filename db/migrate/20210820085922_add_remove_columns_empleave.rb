class AddRemoveColumnsEmpleave < ActiveRecord::Migration[6.1]
  def change
    add_column :empleaves, :cancelled, :boolean, default: false
    add_column :empleaves, :notified, :boolean, default: false
    add_column :empleaves, :half_day_for, :string
    remove_column :empleaves, :end_time
  end
end
