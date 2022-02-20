class CreateDeviceTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :device_types do |t|
      t.column :device_type, :string
    end
  end
end
