class AddLeaveIdentifierInEmpleave < ActiveRecord::Migration[6.1]
  def change
    add_column :empleaves, :leave_identifier, :string
  end
end
