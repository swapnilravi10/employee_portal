class Dashboard::PayrollController < ApplicationController
    skip_before_action :verify_authenticity_token

    def list
        if current_user.role? :superadmin
            @employees = User.all.order('first_name ASC').page params[:page]
        # elsif current_user.role? :program_manager 
        #     team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
        #     team_member_ids = TeamMember.where(team_id: team_ids)
        #     user_ids = User.where(:is_admin => false, :archived => false, id: team_ids).pluck(:id)
        #     @employees = User.where(id: user_ids).page params[:page]
        else current_user.role? :admin or current_user.role? :program_manager or current_user.role? :employee
            @employees = User.where(:id => current_user.id).page params[:page]
        # else
        #     @employees = User.where(:is_admin => false, :archived => false).order('first_name ASC').page params[:page]
        end
        add_breadcrumb('Payroll')
    end

    def edit
        return link_jump() if !helpers.access_document(session[:user_id],params[:id])
        @employee = User.find(params[:id])
        date = Date.today.strftime("%Y-%m")
        @payroll = Payroll.where(user_id: @employee.id ,month: (Date.today.beginning_of_month..Date.today.end_of_month))
        @bankdetail = Bankdetail.find_by_user_id(params[:id])
        @vacation_days_taken = Empleave.where(start_time: Date.today.beginning_of_month.beginning_of_week..Date.today.end_of_month.end_of_week, approved: true, requestee_id: params[:id],wfh:false)
        total_leaves_in_year = Empleave.where(start_time: Date.today.beginning_of_year.beginning_of_month..Date.today.end_of_year.end_of_month, approved: true, requestee_id: params[:id], wfh:false)
        yearly_leave = Setup.last
        if total_leaves_in_year.count > yearly_leave.yearly_leaves
            @leave_without_pay = total_leaves_in_year.count.to_i - yearly_leave.yearly_leaves.to_i
            @days_paid = (Date.today.end_of_month.day).to_i - @leave_without_pay
        end
        if !@employee.designation_id.blank?
            @designation = Designation.find(@employee.designation_id)
        end
        if date == @employee.date_of_joining.strftime("%Y-%m")
            @days_paid = (Date.today.end_of_month.day).to_i - (@employee.date_of_joining.day).to_i
        end
        add_breadcrumb('Employees', dashboard_payroll_path)
        add_breadcrumb('Manage employee payroll')
    end

    def update
        @payroll = Payroll.find(params[:id])
        @previous_month_payroll = Payroll.find_by(user_id: @payroll.user_id, month: @payroll.month.prev_month) 
        if !@previous_month_payroll.blank?
            ####If previous months exists then calculations are done diffrently

            #calculate total earning for this month
            earning_total_current_month = payroll_params[:basic_current_month].to_f + 
            payroll_params[:dearness_allowance_current_month].to_f + payroll_params[:conveyance_allowance_current_month].to_f +
            payroll_params[:house_rent_allowance_current_month].to_f + payroll_params[:professional_development_allowance_current_month].to_f +
            payroll_params[:children_education_allowance_current_month].to_f + payroll_params[:telephone_expense_allowance_current_month].to_f + 
            payroll_params[:medical_allowance_current_month].to_f + payroll_params[:others_current_month].to_f   
            

            #calculate earning to date 
            payroll_params[:basic_to_date] = payroll_params[:basic_current_month].to_f + @previous_month_payroll.basic_to_date.to_f
            payroll_params[:dearness_allowance_to_date] = payroll_params[:dearness_allowance_current_month].to_f + @previous_month_payroll.dearness_allowance_to_date.to_f
            payroll_params[:conveyance_allowance_to_date] = payroll_params[:conveyance_allowance_current_month].to_f + @previous_month_payroll.conveyance_allowance_to_date.to_f
            payroll_params[:house_rent_allowance_to_date] = payroll_params[:house_rent_allowance_current_month].to_f + @previous_month_payroll.house_rent_allowance_to_date.to_f
            payroll_params[:professional_development_allowance_to_date] = payroll_params[:professional_development_allowance_current_month].to_f + @previous_month_payroll.professional_development_allowance_to_date.to_f
            payroll_params[:children_education_allowance_to_date] = payroll_params[:children_education_allowance_current_month].to_f + @previous_month_payroll.children_education_allowance_to_date.to_f
            payroll_params[:telephone_expense_allowance_to_date] = payroll_params[:telephone_expense_allowance_current_month].to_f + @previous_month_payroll.telephone_expense_allowance_to_date.to_f
            payroll_params[:medical_allowance_to_date] = payroll_params[:medical_allowance_current_month].to_f + @previous_month_payroll.medical_allowance_to_date.to_f 
            payroll_params[:others_to_date] = payroll_params[:others_current_month].to_f + @previous_month_payroll.others_to_date.to_f

            #calcualte total earning for to date
            earning_total_to_date = payroll_params[:basic_to_date].to_f + 
                payroll_params[:dearness_allowance_to_date].to_f + payroll_params[:conveyance_allowance_to_date].to_f +
                payroll_params[:house_rent_allowance_to_date].to_f + payroll_params[:professional_development_allowance_to_date].to_f +
                payroll_params[:children_education_allowance_to_date].to_f + payroll_params[:telephone_expense_allowance_to_date].to_f + 
                payroll_params[:medical_allowance_to_date].to_f + payroll_params[:others_to_date].to_f
            
            #calculate total deduction of current month 
            deduction_total_current_month = payroll_params[:professional_tax_current_month].to_f + payroll_params[:income_tax_current_month].to_f + 
                payroll_params[:salary_advance_current_month].to_f + payroll_params[:other_current_month].to_f

            #calculate deduction to date
            payroll_params[:professional_tax_to_date] =  payroll_params[:professional_tax_current_month].to_f +  @previous_month_payroll.professional_tax_to_date.to_f
            payroll_params[:income_tax_to_date] =  payroll_params[:income_tax_current_month].to_f +  @previous_month_payroll.income_tax_to_date.to_f
            payroll_params[:salary_advance_to_date] = payroll_params[:salary_advance_current_month].to_f +  @previous_month_payroll.salary_advance_to_date.to_f
            payroll_params[:other_to_date] = payroll_params[:other_current_month].to_f +  @previous_month_payroll.other_to_date.to_f

            #calculate total deduction of to date    
            deduction_total_to_date = payroll_params[:professional_tax_to_date].to_f + payroll_params[:income_tax_to_date].to_f + 
                payroll_params[:salary_advance_to_date].to_f + payroll_params[:other_to_date].to_f

            net_current_pay = earning_total_current_month - deduction_total_current_month
        else
            #calculate total earning for this month
            earning_total_current_month = payroll_params[:basic_current_month].to_f + 
            payroll_params[:dearness_allowance_current_month].to_f + payroll_params[:conveyance_allowance_current_month].to_f +
            payroll_params[:house_rent_allowance_current_month].to_f + payroll_params[:professional_development_allowance_current_month].to_f +
            payroll_params[:children_education_allowance_current_month].to_f + payroll_params[:telephone_expense_allowance_current_month].to_f + 
            payroll_params[:medical_allowance_current_month].to_f + payroll_params[:others_current_month].to_f   
        
            #calculate earning to date 
            payroll_params[:basic_to_date] = payroll_params[:basic_current_month].to_f + payroll_params[:basic_to_date].to_f
            payroll_params[:dearness_allowance_to_date] = payroll_params[:dearness_allowance_current_month].to_f + payroll_params[:dearness_allowance_to_date].to_f
            payroll_params[:conveyance_allowance_to_date] = payroll_params[:conveyance_allowance_current_month].to_f + payroll_params[:conveyance_allowance_to_date].to_f
            payroll_params[:house_rent_allowance_to_date] = payroll_params[:house_rent_allowance_current_month].to_f + payroll_params[:house_rent_allowance_to_date].to_f
            payroll_params[:professional_development_allowance_to_date] = payroll_params[:professional_development_allowance_current_month].to_f + payroll_params[:professional_development_allowance_to_date].to_f
            payroll_params[:children_education_allowance_to_date] = payroll_params[:children_education_allowance_current_month].to_f + payroll_params[:children_education_allowance_to_date].to_f
            payroll_params[:telephone_expense_allowance_to_date] = payroll_params[:telephone_expense_allowance_current_month].to_f + payroll_params[:telephone_expense_allowance_to_date].to_f
            payroll_params[:medical_allowance_to_date] = payroll_params[:medical_allowance_current_month].to_f + payroll_params[:medical_allowance_to_date].to_f 
            payroll_params[:others_to_date] = payroll_params[:others_current_month].to_f + payroll_params[:others_to_date].to_f

            #calcualte total earning for to date
            earning_total_to_date = payroll_params[:basic_to_date].to_f + 
                payroll_params[:dearness_allowance_to_date].to_f + payroll_params[:conveyance_allowance_to_date].to_f +
                payroll_params[:house_rent_allowance_to_date].to_f + payroll_params[:professional_development_allowance_to_date].to_f +
                payroll_params[:children_education_allowance_to_date].to_f + payroll_params[:telephone_expense_allowance_to_date].to_f + 
                payroll_params[:medical_allowance_to_date].to_f + payroll_params[:others_to_date].to_f

            
            #calculate total deduction of current month 
            if payroll_params[:professional_tax_current_month] == "0.0"
                payroll_params[:professional_tax_current_month] = 200
            end
            
            deduction_total_current_month = payroll_params[:professional_tax_current_month].to_f + payroll_params[:income_tax_current_month].to_f + 
                payroll_params[:salary_advance_current_month].to_f + payroll_params[:other_current_month].to_f

            #calculate deduction to date
            if payroll_params[:professional_tax_to_date] == "0.0"
                payroll_params[:professional_tax_to_date] = 200
            end
            payroll_params[:professional_tax_to_date] =  payroll_params[:professional_tax_current_month].to_f + payroll_params[:professional_tax_to_date].to_f
            payroll_params[:income_tax_to_date] =  payroll_params[:income_tax_current_month].to_f + payroll_params[:income_tax_to_date].to_f
            payroll_params[:salary_advance_to_date] = payroll_params[:salary_advance_current_month].to_f + payroll_params[:salary_advance_to_date].to_f
            payroll_params[:other_to_date] = payroll_params[:other_current_month].to_f + payroll_params[:other_to_date].to_f

            #calculate total deduction of to date    
            deduction_total_to_date = payroll_params[:professional_tax_to_date].to_f + payroll_params[:income_tax_to_date].to_f + 
                payroll_params[:salary_advance_to_date].to_f + payroll_params[:other_to_date].to_f

            net_current_pay = earning_total_current_month - deduction_total_current_month
        end

        payroll_params[:earning_total_current_month] = earning_total_current_month
        payroll_params[:earning_total_to_date] = earning_total_to_date
        payroll_params[:deduction_total_current_month] = deduction_total_current_month
        payroll_params[:deduction_total_to_date] = deduction_total_to_date
        payroll_params[:net_current_pay] = net_current_pay
        payroll_params[:month] = @payroll.month

        if @payroll.update(payroll_params)
            flash.notice = "Payroll upadated successfully"
            ## Sidekiq worker to perform calculations for upcoming months
            CalculatePayrollForFutureMonthsWorker.perform_async(@payroll.user_id, @payroll.month)
            redirect_to :action => 'edit', :id => @payroll.user_id
        else
            flash.now[:alert] = @payroll.errors.full_messages[0]
            add_breadcrumb('Employees', dashboard_payroll_path)
            add_breadcrumb('Manage employee payroll')
            render :action => 'edit'
        end
    end
    def payroll_params
        params.require(:payroll).permit!
    end

    def month_payroll
        date_param = "#{params[:month]}-01"
        date = Date.strptime(date_param,'%Y-%m-%d')
        user = params[:user]
        @employee = User.find(user)
        @payroll = Payroll.where(user_id: user ,month: (date.beginning_of_month..date.end_of_month))
        @bankdetail = Bankdetail.find_by_user_id(params[:user])
        @vacation_days_taken = Empleave.where(start_time: date.beginning_of_month.beginning_of_week..date.end_of_month.end_of_week, approved: true, requestee_id: params[:user], wfh:false)
        total_leaves_in_year = Empleave.where(start_time: date.beginning_of_year.beginning_of_month..date.end_of_year.end_of_month, approved: true, requestee_id: params[:user], wfh:false)
        yearly_leave = Setup.last
        if total_leaves_in_year.count > yearly_leave.yearly_leaves
            @leave_without_pay = total_leaves_in_year.count.to_i - yearly_leave.yearly_leaves.to_i
            @days_paid = ((date_param).to_date.end_of_month.day).to_i - @leave_without_pay
        end
        if !@employee.designation_id.blank?
            @designation = Designation.find(@employee.designation_id)
        end
        if params[:month] == @employee.date_of_joining.strftime("%Y-%m")
            @days_paid = ((date_param).to_date.end_of_month.day).to_i - (@employee.date_of_joining.day).to_i
        end
        pdf_name = ((@employee.first_name).strip+'_'+@employee.last_name+'_'+date.strftime("%B_%y")).downcase
        respond_to do |format|
            format.js {render 'edit.js.erb'}
            format.pdf do 
                render pdf: "#{pdf_name}", template: "dashboard/payroll/payrollpdf.html.erb"
            end
        end
    end
end
