class CreateUserstatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :userstatuses do |t|
      t.column :user_id, :integer, null: true
      t.column :status_id, :integer, null: true
    end
  end
end
