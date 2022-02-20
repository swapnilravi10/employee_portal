class CreateEmpleaves < ActiveRecord::Migration[6.1]
  def change
    create_table :empleaves do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.boolean :approved
      t.boolean :half_day
      t.datetime :approval_date
      t.references :requestee, null: false,  foreign_key: { to_table: :users }
      t.references :attendee, null: false,  foreign_key: { to_table: :users }
      t.datetime :rejection_date
      t.timestamps
    end
  end
end
