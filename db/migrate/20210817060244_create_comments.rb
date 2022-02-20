class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.column :comment, :text
      t.column :user_id, :integer
      t.column :post_id, :integer 
      t.timestamps
    end
  end
end
