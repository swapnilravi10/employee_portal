class CreatePostLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :post_likes do |t|
      t.column :post_id, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end
end
