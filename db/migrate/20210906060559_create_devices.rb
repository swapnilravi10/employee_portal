class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.column :name, :string
      t.column :device_type_id, :integer
      t.column :description, :text
    end
  end
end
