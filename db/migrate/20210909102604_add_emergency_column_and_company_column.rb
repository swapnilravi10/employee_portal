class AddEmergencyColumnAndCompanyColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :emergency_contact_name, :string
    add_column :users, :emergency_contact_number, :integer, limit: 8
    add_column :clients, :company_email, :string
    add_column :clients, :company_registration_number, :integer
  end
end
