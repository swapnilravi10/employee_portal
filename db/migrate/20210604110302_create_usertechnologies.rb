class CreateUsertechnologies < ActiveRecord::Migration[6.1]
  def change
    create_table :usertechnologies do |t|

      t.column :user_id, :integer
      t.column :technology_id, :integer
      
    end
  end
end
