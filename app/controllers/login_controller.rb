class LoginController < ApplicationController

    skip_before_action :verify_authenticity_token  

    def login_user
        @user = User.find_by_email(login_params[:email])
        if @user.blank?
          redirect_back(fallback_location: root_path)
          flash.alert = "Please enter correct email and password."
        else
            @time = Time.new
            if @user.archived == true
                flash.alert = "This account has been deactivated."
                render :action => 'login'
                return
            end
            if @user && @user.authenticate(login_params[:password])
                session[:user_id] = @user.id
                @user.logged_in = true
                @user.logged_in_at = @time.strftime("%Y-%m-%d %H:%M:%S")
                @user.save
                @user_status = Userstatus.find_or_create_by(:user_id => @user.id)
                @user_status.status_id = 6
                @user_status.save
                flash.notice = "Login successfully"
                redirect_to :action => 'index', :controller=>"dashboard/admin"
            else
                flash.alert = "Incorrect credentials"
                render :action => 'login'
            end
        end
    end
    def login_params
        params.require(:login).permit(:email, :password)
    end

    def register
    end

    def create
        @user = User.new(user_params)
        @payroll = Payroll.new
        if @user.valid?
            @user.save
            @role = Role.find(5)
            @assignment = Assignment.new(:role_id => @role.id, :user_id => @user.id)
            if @assignment.valid?
                @assignment.save
            else
                flash.now[:alert] = @assignment.errors.full_messages[0]
                redirect_to :action => 'register'
            end
            @payroll.user_id = @user.id
            @payroll.month = @user.date_of_joining
            @payroll.save
            self.create_payroll(@user.id, @user.date_of_joining)
            flash.notice = "Registration successful"
            redirect_to :action => 'login'
        else
            flash.now[:alert] = @user.errors.full_messages[0]
            render :action => 'register'
        end 
    end
    def user_params
        params.require(:register).permit(:first_name, :last_name, :email, :phone_number, :password,:password_confirmation,:adhar_card_number,:date_of_joining, :emergency_contact_name, :emergency_contact_number, :designation_id, )
    end

    def logout_user
        @user = User.find(session[:user_id])
        @user.logged_in = false
        @user.save
        session[:user_id] = nil  
        redirect_to :action => 'login'
        flash.notice = "Logout successfully"
    end

    def reset_password
        @user = User.find_by_hashid(params[:hashid])
    end

    def reset_password_process
        @user = User.find_by_hashid(params[:hashid])
        if password_reset_params[:password] != password_reset_params[:password_confirmation]
            flash.alert = "Passwords do not match."
            render :action => 'reset_password'
            return
        end
        if @user.update(password_reset_params)
            @user.save
            flash.notice = "Password reset successful"
            render :action => 'login'
            return
        else
            flash.now[:alert] = @user.errors.full_messages[0]
            render :action => 'reset_password'
            return
        end
    end
    def password_reset_params
        params.require(:reset_password).permit(:password, :password_confirmation)
    end

    def forgot_password
    end

    def forgot_password_process
        @employee = User.find_by_email(forgot_password_params[:email])
        if @employee.present?
            @url  = "#{request.protocol + request.host + +':' + request.port.to_s}#{login_reset_password_path(@employee.hashid)}"
            NewUserMailer.send_reset_password_link(@employee,@url).deliver_now
            flash.notice = "Email sent successfully"
            redirect_to :action => 'login'
        else
            flash.alert = "Employee not present."
            redirect_to :action => 'login'
        end
    end
    def forgot_password_params
        params.require(:forgot_password).permit(:email)
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
end
