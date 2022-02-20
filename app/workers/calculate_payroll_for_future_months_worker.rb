class CalculatePayrollForFutureMonthsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, payroll_month)
    month = Date.strptime(payroll_month, "%Y-%m-%d")
    record_count = Payroll.where(:user_id => user_id).count
    @payroll = Payroll.find_by(user_id: user_id, month: month)
    initial_flag = 1
    while initial_flag < record_count
      ##@update_payroll is the one to be updated i.e next/upcoming months
      @update_payroll = Payroll.find_by(user_id: user_id, month: month.next_month)
      ##@previous_payroll is the previous months payroll which
      # is refrenced for next calculations
      @previous_payroll = Payroll.find_by(user_id: user_id, month: @update_payroll.month.prev_month)

      @update_payroll.basic_current_month = @previous_payroll.basic_current_month
      @update_payroll.dearness_allowance_current_month = @previous_payroll.dearness_allowance_current_month
      @update_payroll.conveyance_allowance_current_month = @previous_payroll.conveyance_allowance_current_month
      @update_payroll.house_rent_allowance_current_month = @previous_payroll.house_rent_allowance_current_month
      @update_payroll.professional_development_allowance_current_month = @previous_payroll.professional_development_allowance_current_month
      @update_payroll.children_education_allowance_current_month = @previous_payroll.children_education_allowance_current_month
      @update_payroll.telephone_expense_allowance_current_month = @previous_payroll.telephone_expense_allowance_current_month
      @update_payroll.medical_allowance_current_month = @previous_payroll.medical_allowance_current_month
      @update_payroll.others_current_month = @previous_payroll.others_current_month
      @update_payroll.earning_total_current_month = @previous_payroll.earning_total_current_month

      @update_payroll.professional_tax_current_month = @previous_payroll.professional_tax_current_month
      @update_payroll.income_tax_current_month = @previous_payroll.income_tax_current_month
      @update_payroll.salary_advance_current_month = @previous_payroll.salary_advance_current_month
      @update_payroll.other_current_month = @previous_payroll.other_current_month

      @update_payroll.deduction_total_current_month = @previous_payroll.deduction_total_current_month


      @update_payroll.basic_to_date = @previous_payroll.basic_to_date.to_f + @previous_payroll.basic_current_month.to_f
      @update_payroll.dearness_allowance_to_date = @previous_payroll.dearness_allowance_to_date.to_f + @previous_payroll.dearness_allowance_current_month.to_f
      @update_payroll.conveyance_allowance_to_date = @previous_payroll.conveyance_allowance_to_date.to_f + @previous_payroll.conveyance_allowance_current_month.to_f
      @update_payroll.house_rent_allowance_to_date = @previous_payroll.house_rent_allowance_to_date.to_f + @previous_payroll.house_rent_allowance_current_month.to_f
      @update_payroll.professional_development_allowance_to_date = @previous_payroll.professional_development_allowance_to_date.to_f + @previous_payroll.professional_development_allowance_current_month.to_f
      @update_payroll.children_education_allowance_to_date = @previous_payroll.children_education_allowance_to_date.to_f + @previous_payroll.children_education_allowance_current_month.to_f
      @update_payroll.telephone_expense_allowance_to_date = @previous_payroll.telephone_expense_allowance_to_date.to_f + @previous_payroll.telephone_expense_allowance_current_month.to_f
      @update_payroll.medical_allowance_to_date = @previous_payroll.medical_allowance_to_date.to_f + @previous_payroll.medical_allowance_current_month.to_f
      @update_payroll.others_to_date = @previous_payroll.others_to_date.to_f + @previous_payroll.others_current_month.to_f
      @update_payroll.month = @update_payroll.month
      @update_payroll.earning_total_to_date = @update_payroll.basic_to_date.to_f + @update_payroll.dearness_allowance_to_date.to_f +
        @update_payroll.conveyance_allowance_to_date.to_f + @update_payroll.house_rent_allowance_to_date.to_f + @update_payroll.professional_development_allowance_to_date.to_f +
        @update_payroll.children_education_allowance_to_date.to_f + @update_payroll.telephone_expense_allowance_to_date + 
        @update_payroll.medical_allowance_to_date.to_f + @update_payroll.others_to_date.to_f
      
      @update_payroll.professional_tax_to_date = @previous_payroll.professional_tax_to_date.to_f + @previous_payroll.professional_tax_current_month.to_f
      @update_payroll.income_tax_to_date = @previous_payroll.income_tax_to_date.to_f + @previous_payroll.income_tax_current_month.to_f
      @update_payroll.salary_advance_to_date = @previous_payroll.salary_advance_to_date.to_f + @previous_payroll.salary_advance_current_month.to_f
      @update_payroll.other_to_date = @previous_payroll.other_to_date.to_f + @previous_payroll.other_current_month.to_f
      @update_payroll.deduction_total_to_date = @update_payroll.professional_tax_to_date + @update_payroll.income_tax_to_date +
        @update_payroll.salary_advance_to_date + @update_payroll.other_to_date

      @update_payroll.net_current_pay = @update_payroll.earning_total_current_month.to_f - @update_payroll.deduction_total_current_month.to_f

      attributes = {
                    "basic_to_date" => @update_payroll.basic_to_date, "dearness_allowance_to_date" => @update_payroll.dearness_allowance_to_date,
                    "conveyance_allowance_to_date" => @update_payroll.conveyance_allowance_to_date, "house_rent_allowance_to_date" => @update_payroll.house_rent_allowance_to_date,
                    "professional_development_allowance_to_date" => @update_payroll.professional_development_allowance_to_date, "children_education_allowance_to_date" => @update_payroll.children_education_allowance_to_date,
                    "telephone_expense_allowance_to_date" => @update_payroll.telephone_expense_allowance_to_date, "medical_allowance_to_date" => @update_payroll.medical_allowance_to_date,
                    "others_to_date" => @update_payroll.others_to_date, "earning_total_to_date" => @update_payroll.earning_total_to_date,
                    "professional_tax_to_date" => @update_payroll.professional_tax_to_date, "income_tax_to_date" => @update_payroll.income_tax_to_date,
                    "salary_advance_to_date" => @update_payroll.salary_advance_to_date, "other_to_date" => @update_payroll.other_to_date,
                    "net_current_pay" => @update_payroll.net_current_pay, "month" => @update_payroll.month,
                    "deduction_total_to_date" => @update_payroll.deduction_total_to_date
                  }
      @update_payroll.update(attributes)
      month = @update_payroll.month
      initial_flag+=1
    end
  end
end
