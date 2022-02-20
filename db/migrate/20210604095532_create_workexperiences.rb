class CreateWorkexperiences < ActiveRecord::Migration[6.1]
  def change
    create_table :workexperiences do |t|

      t.column :user_id, :integer
      t.column :duration_of_work, :float
      t.column :role, :string
      
    end
  end
end
