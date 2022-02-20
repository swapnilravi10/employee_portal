class CreateSetups < ActiveRecord::Migration[6.1]
  def change
    create_table :setups do |t|
      t.integer :yearly_leaves

      t.timestamps
    end
  end
end
