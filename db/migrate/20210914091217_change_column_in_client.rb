class ChangeColumnInClient < ActiveRecord::Migration[6.1]
  def change
    change_column :clients, :company_registration_number, :string
  end
end
