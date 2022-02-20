class Users < ActiveRecord::Migration[6.1]
  def self.up
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :otp, :string
      t.column :email, :string, :null => false
      t.column :password_digest, :string
      t.column :phone_number , :integer, limit: 8
      t.column :is_admin, :boolean, :default => "false"
      t.column :archived, :boolean, :default => "false"
      t.column :date_of_joining, :datetime
      t.column :archival_date, :datetime
      t.column :logged_in_at, :datetime
      t.column :adhar_card_number, :string
      t.column :pan_card_number, :string
      t.column :logged_in, :boolean, default: false
    end
  end
  def self.down
    drop_table :users
  end
end
