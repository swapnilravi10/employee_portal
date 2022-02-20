class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.string :year
      t.datetime :date
      t.boolean :halfday
      t.integer :user_id, foreign_key: true, index: true
      t.timestamps
    end
  end
end
