class CreateEvents < ActiveRecord::Migration[6.1]
  def self.up
    create_table :events do |t|
      t.column :event_name, :string
      t.column :start_time, :timestamp
      t.column :end_time, :timestamp
      t.column :holiday, :boolean, default: false
    end
  end
  def self.down
    drop_table :events
  end
end
