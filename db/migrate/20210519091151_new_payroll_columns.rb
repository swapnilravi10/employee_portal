class NewPayrollColumns < ActiveRecord::Migration[6.1]
  def self.up
    create_table :payrolls do |t|
      t.column :user_id, :integer
      t.column :vacation_days_taken, :integer
      t.column :vacation_days_ytd, :integer
      t.column :leave_without_pay, :integer
      t.column :basic_current_month, :float, :default => 0.00
      t.column :basic_to_date, :float, :default => 0.00
      t.column :dearness_allowance_current_month, :float, :default => 0.00
      t.column :dearness_allowance_to_date, :float, :default => 0.00
      t.column :conveyance_allowance_current_month, :float, :default => 0.00
      t.column :conveyance_allowance_to_date, :float, :default => 0.00
      t.column :house_rent_allowance_current_month, :float, :default => 0.000
      t.column :house_rent_allowance_to_date, :float, :default => 0.000
      t.column :professional_development_allowance_current_month, :float, :default => 0.00
      t.column :professional_development_allowance_to_date, :float, :default => 0.00
      t.column :children_education_allowance_current_month, :float, :default => 0.00
      t.column :children_education_allowance_to_date, :float, :default => 0.00
      t.column :telephone_expense_allowance_current_month, :float, :default => 0.00
      t.column :telephone_expense_allowance_to_date, :float, :default => 0.00
      t.column :medical_allowance_current_month, :float, :default => 0.00
      t.column :medical_allowance_to_date, :float, :default => 0.00
      t.column :others_current_month, :float, :default => 0.00
      t.column :others_to_date, :float, :default => 0.00
      t.column :professional_tax_current_month, :float, :default => 0.00
      t.column :professional_tax_to_date, :float, :default => 0.00
      t.column :income_tax_current_month, :float, :default => 0.00
      t.column :income_tax_to_date, :float, :default => 0.00
      t.column :salary_advance_current_month, :float, :default => 0.00
      t.column :salary_advance_to_date, :float, :default => 0.00
      t.column :other_current_month, :float, :default => 0.00
      t.column :other_to_date, :float, :default => 0.00
      t.column :month, :date
      t.column :earning_total_current_month, :float, :default => 0.0
      t.column :earning_total_to_date, :float, :default => 0.0
      t.column :net_current_pay, :float, :default => 0.0
      t.column :deduction_total_current_month, :float, :default => 0.0
      t.column :deduction_total_to_date, :float, :default => 0.0
    end
  end
  def self.down
    drop_table :payrolls
  end
end
