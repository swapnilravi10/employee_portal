class CreateEmployeeeducations < ActiveRecord::Migration[6.1]
  def self.up
    create_table :employeeeducations do |t|
      t.column :highest_education, :string
      t.column :university, :string, null: true
      t.column :college, :string, null: true
      t.column :user_id, :integer
      t.column :year_of_passing, :integer
    end
  end
  def self.down
    drop_table :employeeeducations
  end
end
