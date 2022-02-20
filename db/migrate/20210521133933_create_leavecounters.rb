class CreateLeavecounters < ActiveRecord::Migration[6.1]
  def change
    create_table :leavecounters do |t|
      t.decimal :leaves
      t.string :year
      t.integer :user_id, foreign_key: true, index: true
      t.timestamps
    end
  end
end
