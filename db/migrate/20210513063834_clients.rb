class Clients < ActiveRecord::Migration[6.1]
  def self.up 
    create_table :clients do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :company_name, :string
      t.column :email, :string
      t.column :phone_number, :integer, limit: 8
      t.column :country, :string
    end
  end
  def self.down
    drop_table :clients
  end
end
