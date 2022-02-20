class AddEndTimeToEmpleaves < ActiveRecord::Migration[6.1]
  def change
    add_column :empleaves, :end_time, :datetime
    add_column :empleaves, :wfh, :boolean, default: false
  end
end
