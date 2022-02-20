class CreateBankdetails < ActiveRecord::Migration[6.1]
  def change
    create_table :bankdetails do |t|
      t.string :bank_name
      t.string :account_number
      t.string :ifsc_code

      t.timestamps
    end
  end
end
