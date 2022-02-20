class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.column :post, :text
      t.column :like, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end
end
