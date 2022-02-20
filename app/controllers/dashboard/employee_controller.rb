class Dashboard::EmployeeController < ApplicationController

    skip_before_action :verify_authenticity_token  
    
    def index
        redirect_to :action => 'list'
    end

    def list
        return link_jump() if !helpers.access_controller(session[:user_id])
        @employees = User.all.order('first_name ASC').page params[:page]
        add_breadcrumb('Employees')
    end

    def new
        return link_jump() if !helpers.access_controller(session[:user_id])
        @employee = User.new
        @roles = Role.all
        @designations = Designation.all
        @pay_roll = Payroll.new
        @bankdetail = Bankdetail.new
        @employeeeducation = Employeeeducation.new
        @technology = Technology.all
        @workexperience = Workexperience.new
        @usertechnologies = Usertechnology.new
        add_breadcrumb('Employees', dashboard_employee_list_path)
        add_breadcrumb('New employee')
    end

    def create
        @employee = User.new(new_user_params)
        @roles = Role.all
        @designations = Designation.all
        @payroll = Payroll.new
        @bankdetail = Bankdetail.new(new_bank_details)
        @technology = Technology.all
        @employeeeducation = Employeeeducation.new(new_education_details)
        @workexperience = Workexperience.new(new_work_exp)
        
        employee = User.find_by(email: @employee.email)

        if employee.present?
            flash.now[:alert] = "User with same email already exists."
            render :action => 'new'
        else
            if @employee.valid?
                @employee.archived = false
                @employee.save
                for id in new_role_params[:id]
                    if !id.blank?
                        @assignment = Assignment.new(:role_id => id.to_i, :user_id => @employee.id)
                        @assignment.save
                        @role = Role.find_by(:id => id.to_i)
                        if @role.name != "employee"
                            @employee.is_admin = true
                            @employee.save
                        end
                    end
                end
                @bankdetail.user_id = @employee.id
                @bankdetail.save
                
                @employeeeducation.user_id = @employee.id
                @employeeeducation.save
    
                @workexperience.user_id = @employee.id
                @workexperience.save
                for id in new_user_tech[:technology_id]
                    if !id.blank?
                        @usertechnologies = Usertechnology.new
                        @usertechnologies.user_id = @employee.id
                        @usertechnologies.technology_id = id
                        @usertechnologies.save
                    end
                end
                @payroll.user_id = @employee.id
                @payroll.month = @employee.date_of_joining
                @payroll.save
                self.create_payroll(@employee.id, @employee.date_of_joining)
                flash.notice = "Employee added succesfully"
                otp = rand.to_s[2..5] 
                @employee.otp = otp
                @employee.save
                @url  = "#{request.protocol + request.host + +':' + request.port.to_s}#{login_reset_password_path(@employee.hashid)}"
                NewUserMailer.user_registered(@employee,current_user,@url)
                redirect_to :action => 'list'
            else
                flash.now[:alert] = "All the basic details are compulsory."
                add_breadcrumb('Employees', dashboard_employee_list_path)
                add_breadcrumb('New employee')
                render :action => 'new'
            end
        end
    end

    def new_user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone_number, :date_of_joining, :designation_id, :adhar_card_number, :pan_card_number, :emergency_contact_name, :emergency_contact_number)
    end
    def new_role_params
        params.require(:role).permit(:id =>[])
    end
    def new_bank_details
        params.require(:bankdetail).permit(:bank_name, :account_number, :ifsc_code)
    end
    def new_education_details
        params.require(:employeeeducation).permit(:year_of_passing, :highest_education, :college, :university)
    end
    def new_work_exp
        params.require(:workexperience).permit(:duration_of_work, :role)
    end
    def new_user_tech
        params.require(:usertechnologies).permit(:technology_id =>[])
    end

    def edit
        return link_jump() if !helpers.access_controller(session[:user_id])
        @employee = User.find(params[:id])
        @all_roles = Role.all
        @designations = Designation.all
        @assignment = Assignment.find_by(:user_id => params[:id])
        @bankdetail = Bankdetail.find_by(:user_id => params[:id])
        @employeeeducation = Employeeeducation.find_by(:user_id => params[:id])
        @user_tech = Usertechnology.where(:user_id => params[:id])
        ids_to_exclude = []
        for id in @user_tech
            ids_to_exclude.push(id.technology_id)
        end

        items_table = Arel::Table.new(:technologies)

        @technology = Technology.where(items_table[:id].not_in ids_to_exclude)
        @workexperience = Workexperience.find_by(:user_id => params[:id])
        
        @usertechnologies = Usertechnology.find_or_create_by(:user_id => params[:id])
        add_breadcrumb('Employees', dashboard_employee_list_path)
        add_breadcrumb('Edit employee')
    end
         
    def update
        if params[:archive]
            @employee = User.find(params[:user_id])
            if Date.parse(user_params[:archival_date].to_s)< Date.today
                flash.alert = "Archival date cannot be a past date"
                add_breadcrumb('Employees', dashboard_employee_list_path)
                redirect_to action: 'list'
            else
                @employee.archival_date = user_params[:archival_date]
                @employee.save
                flash.notice = "Employee deactivation date set successfully"
                add_breadcrumb('Employees', dashboard_employee_list_path)
                redirect_to action: 'list'
                # render :action => 'list'
            end
        else
            @employee = User.find(params[:id])
            @roles = Role.all
            @designations = Designation.all
            @assignment = Assignment.find_by(:user_id => @employee.id)
            @bankdetail = Bankdetail.find_or_create_by(:user_id => @employee.id)
            @employeeeducation = Employeeeducation.find_or_create_by(:user_id => @employee.id)
            @workexperience = Workexperience.find_or_create_by(:user_id => @employee.id)
            @user_tech = Usertechnology.where(:user_id => @employee.id)
            ids_to_exclude = []
            for id in @user_tech
                ids_to_exclude.push(id.technology_id)
            end
    
            items_table = Arel::Table.new(:technologies)
    
            @technology = Technology.where(items_table[:id].not_in ids_to_exclude)
            if user_params[:password].blank?
                user_params.delete(:password)
            end
            if @employee.archived.eql? true 
                flash.alert = "Inactive employee record cannot be updated"
                redirect_back(fallback_location: root_path)
            else
                if @employee.update(user_params)
                    @employee.save
                    if !update_role[:role_id].blank?
                        @assignment = Assignment.where(:user_id => @employee.id).destroy_all
                        for id in update_role[:role_id]
                            if !id.blank?
                                @assignment = Assignment.new(:role_id => id.to_i, :user_id => @employee.id)
                                @assignment.save
                                @role = Role.find_by(:id => id.to_i)
                                if @role.name != "employee"
                                    @employee.is_admin = true
                                    @employee.save
                                end
                            end
                        end
                    end
                    @bankdetail.bank_name = bank_details[:bank_name]
                    @bankdetail.ifsc_code = bank_details[:ifsc_code]
                    @bankdetail.account_number = bank_details[:account_number]
                    @bankdetail.save

                    @employeeeducation.highest_education = education_details[:highest_education]
                    @employeeeducation.year_of_passing = education_details[:year_of_passing]
                    @employeeeducation.university = education_details[:university]
                    @employeeeducation.college = education_details[:college]
                    @employeeeducation.save
                       
                    if !work_details[:duration_of_work].is_a? Integer
                        flash.now[:alert] = "Workexperience has to be numerical"  
                    end
                    @workexperience.duration_of_work = work_details[:duration_of_work]
                    @workexperience.role = work_details[:role]
                    @workexperience.save
                    for id in user_technology[:technology_id]
                        if !id.blank?
                            @usertechnologies = Usertechnology.find_or_create_by(:user_id => params[:id], :technology_id => id)
                            @usertechnologies.technology_id = id
                            @usertechnologies.user_id = @employee.id
                            @usertechnologies.save
                        end
                    end
                    flash.notice = "Employee updated successfully"
                    redirect_to :action => 'list'
                else
                    flash.now[:alert] = @employee.errors.full_messages[0]
                    add_breadcrumb('Employees', dashboard_employee_list_path)
                    add_breadcrumb('Edit employee')
                    render :action => 'edit'
                end
            end
        end
    end
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :designation_id, :user_id, :archival_date, :archive, :adhar_card_number, :pan_card_number, :emergency_contact_name, :emergency_contact_number)
    end
    def update_role
        params.require(:assignment).permit(:role_id =>[])
    end
    def bank_details
        params.require(:bankdetail).permit(:bank_name, :account_number, :ifsc_code)
    end
    def education_details
        params.require(:employeeeducation).permit(:year_of_passing, :highest_education, :college, :university)
    end
    def work_details
        params.require(:workexperience).permit(:duration_of_work, :role)
    end
    def user_technology
        params.require(:usertechnologies).permit(:technology_id =>[])
    end

    def deactivate
        @employee = User.find(params[:id])
        add_breadcrumb('Employees', dashboard_employee_list_path)
        add_breadcrumb('Edit employee')
    end

    # def deactivate_emp
    #     puts "deacivation called!!!!!!!"
    #     @employee = User.find(deactivate_emp_params[:id])
    #     puts deactivate_emp_params[:archival_date]
    #     # @employee = User.find(deactivate_emp_params[:deactivate])
    #     if @employee.archived.eql? true
    #         flash.alert = "Employee already inactive"
    #         redirect_to :action => 'list'
    #     else
    #         # @employee.archived = true
    #         @employee.archival_date = deactivate_emp_params[:archival_date]
    #         @employee.save
    #         flash.notice = "Employee deactivation set on " + Date.parse(deactivate_emp_params[:archival_date].to_s).strftime("%d-%m-%Y").to_s
    #         redirect_to :action => 'list'
    #     end
    # end
    # # private
    # def deactivate_emp_params
    #     params.require(:user).permit(:id, :archival_date)
    # end
    def activate_emp
        @employee = User.find(params[:id])
        if @employee.archived.eql? false
            flash.alert = "Employee already active"
            redirect_to :action => 'list'
        else
            @employee.archived = false
            @employee.archival_date = nil
            @employee.save
            flash.notice = "Employee activated successfully"
            redirect_to :action => 'list'
        end
    end

    def destroy
        User.find(params[:id]).destroy
        Payroll.where(:user_id => params[:id]).destroy_all
        redirect_to :action => 'list'
    end

    

    def show
        return link_jump() if !helpers.access_document(session[:user_id],params[:id])
        @employee = User.find(params[:id])
        @bankdetail = Bankdetail.find_by(:user_id => params[:id])
        @employeeeducation = Employeeeducation.find_by(:user_id => params[:id])
        @user_tech = Usertechnology.where(:user_id => params[:id])
        @workexperience = Workexperience.find_by(:user_id => params[:id])
        if current_user.id != @employee.id
            add_breadcrumb('Employees', dashboard_employee_list_path)
            add_breadcrumb(@employee.full_name)
        end
    end


    ##Creating a payroll for new user.
    def create_payroll(id, date_of_joining)
        n = 1
        date = date_of_joining
        while n<=240
            @payroll = Payroll.new
            next_date = date.next_month
            date = next_date
            n+=1
            @payroll.user_id = id
            @payroll.month = next_date
            @payroll.save
        end
    end

    def destroy_user_tech
        query = Usertechnology.find(params[:id])
        user = query
        query.destroy
        redirect_to :action => 'edit', :id => user.user_id
    end

    def documents
        return link_jump() if !helpers.access_document(session[:user_id],params[:id])
        @user = User.find(params[:id])
        s3_client = Aws::S3::Client.new(
            access_key_id: AWS_CONFIG::ACCESS_KEY_ID,
            secret_access_key: AWS_CONFIG::SECRET_ACCESS_KEY,
            region: AWS_CONFIG::REGION
            )
        response = s3_client.list_objects({
            bucket: AWS_CONFIG::BUCKET,
            prefix: "#{@user.id}-#{@user.full_name}/", 
            })
        @files = response
        add_breadcrumb('Employees', dashboard_employee_list_path)
        add_breadcrumb('Documents')  
    end

    def upload_document
        user = User.find(params[:id])
        document = params[:document]
        s3_client = Aws::S3::Client.new(
            access_key_id: AWS_CONFIG::ACCESS_KEY_ID,
            secret_access_key: AWS_CONFIG::SECRET_ACCESS_KEY,
            region: AWS_CONFIG::REGION
            )
        object_uploaded?(s3_client, AWS_CONFIG::BUCKET, document, user)
        redirect_to :action => 'documents'
    end
    def object_uploaded?(s3_client, bucket_name, object_key, user)
        response = s3_client.put_object(
            body: object_key,
            bucket: bucket_name,
            key: "#{user.id}-#{user.full_name}/#{object_key.original_filename}",
            acl: 'public-read',
        )
        if response.etag
            return true
        else
            return false
        end
        rescue StandardError => e
            puts "Error uploading object: #{e.message}"
        return false
    end

    def download_document
        user_id = params[:user]
        file_name = params[:file]
        s3 = Aws::S3::Resource.new(
            access_key_id: AWS_CONFIG::ACCESS_KEY_ID,  
            secret_access_key: AWS_CONFIG::SECRET_ACCESS_KEY,
            region: AWS_CONFIG::REGION,
        )
        obj = s3.bucket( AWS_CONFIG::BUCKET).object(file_name)
        url = obj.presigned_url(:get, expires_in: 3600, response_content_disposition: "attachment; filename=#{file_name.split("/")[1]}")
        redirect_to url
    end

    def view_document
        user_id = params[:user]
        file_name = params[:file]
        s3 = Aws::S3::Object.new(
            access_key_id: AWS_CONFIG::ACCESS_KEY_ID,  
            secret_access_key: AWS_CONFIG::SECRET_ACCESS_KEY,
            region: AWS_CONFIG::REGION,
            bucket_name: AWS_CONFIG::BUCKET,
            key: file_name
        )
        obj = s3.public_url
        redirect_to obj
    end

    def delete_document
        user_id = params[:user]
        file_name = params[:file]
        s3 = Aws::S3::Object.new(
            access_key_id: AWS_CONFIG::ACCESS_KEY_ID,  
            secret_access_key: AWS_CONFIG::SECRET_ACCESS_KEY,
            region: AWS_CONFIG::REGION,
            bucket_name: AWS_CONFIG::BUCKET,
            key: file_name
        )
        obj = s3.delete
        redirect_to :action => 'documents', :id => user_id
    end
end