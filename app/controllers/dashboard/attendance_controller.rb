class Dashboard::AttendanceController < ApplicationController

    skip_before_action :verify_authenticity_token

    def index
        if request.get?
            if current_user.role? :employee or current_user.role? :program_manager
                if request.query_parameters.blank?
                    start_time = Date.today
                    @leaves = Empleave.where(start_time: start_time.beginning_of_month.beginning_of_week..start_time.end_of_month.end_of_week, approved: true, requestee_id: current_user.id)
                else
                    start_time = request.query_parameters[:start_date].to_date
                    @leaves = Empleave.where(start_time: start_time.beginning_of_month.beginning_of_week..start_time.end_of_month.end_of_week, approved: true, requestee_id: current_user.id)
                end
            elsif current_user.role? :program_manager
                team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
                team_member_ids = TeamMember.where(team_id: team_ids).pluck(:user_id)
                @users = User.where(:id => team_member_ids)
                @leaves = []
            else
                @users = User.all
                @leaves = []
            end
       
        elsif request.post?
            @users = User.all
            if params[:start_date].blank?
                start_time = Date.today
            else
                start_time = params[:start_date].to_date
            end
            @leaves = Empleave.where(start_time: start_time.beginning_of_month.beginning_of_week..start_time.end_of_month.end_of_week, approved: true, requestee_id: params[:user])
            respond_to do |format|
                format.js {render 'index.js.erb'}
                add_breadcrumb('Attendance')
            end
            
        end
        
        add_breadcrumb('Attendance')
    end

    def work_from_home
        if request.get?
            if current_user.role? :superadmin
                @users = User.all
            elsif current_user.role? :program_manager
                team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
                team_member_ids = TeamMember.where(team_id: team_ids).pluck(:user_id)
                @users = User.where(:id => team_member_ids)
            end
            @empleave = Empleave.new
        elsif request.post?
            @users = User.all
            @empleave = Empleave.new(wfh_params)
            if current_user.role? :employee
                @empleave.requestee_id = current_user.id
            end
            @empleave.attendee_id = current_user.id
            if @empleave.valid?
                @empleave.description = "Work from home"
                @empleave.wfh = true
                @empleave.approved = true
                @empleave.save
                flash.notice = "WFH added succesfully"
                redirect_to :action => 'list_wfh'
            else
                flash.now[:alert] = @empleave.errors.full_messages[0]
                render :action => 'work_from_home'
            end
        end
        add_breadcrumb('Attendance', dashboard_attendance_index_path)
        add_breadcrumb('Work from home', dashboard_attendance_wfh_list_path)
        add_breadcrumb('Add work from home')
    end
    def wfh_params
        params.require(:empleave).permit(:start_time, :end_time, :requestee_id)
    end

    def list_wfh
        if current_user.role? :superadmin 
            @wfh = Empleave.where(approved: true, wfh: true).page params[:page]

        elsif current_user.role? :program_manager
            team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
            team_member_ids = TeamMember.where(team_id: team_ids).pluck(:user_id)
            @wfh = Empleave.where(requestee_id: team_member_ids, approved: true, :wfh => true).page params[:page]

        else
            @wfh = Empleave.where(approved: true, wfh: true, requestee_id: current_user.id ).page params[:page]
        end
        add_breadcrumb('Attendance', dashboard_attendance_index_path)
        add_breadcrumb('Work from home')
    end

    def destroy
        Empleave.find(params[:id]).destroy
        flash.notice = "WFH deleted succesfully"
        redirect_to :action => 'list_wfh'
    end

    def user_params
        params.require(:attendance).permit(:user_id) 
    end
end
