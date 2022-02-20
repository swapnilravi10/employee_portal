class Dashboard::EmpleaveController < ApplicationController
    
    def index
        redirect_to :action => 'list'
    end

    def new
        @emp_leave = Empleave.new
        # @users = User.where(:is_admin => false)
        @users = User.where(:archived => false)
        add_breadcrumb('Leaves', dashboard_empleave_list_path)
        add_breadcrumb('New Leave')
    end

    def create
      @users = User.where(:archived => false)
      @records = []
      check_dates = []
      result = nil
      new_leave_params_array[:start_time].each do |s| 
        check_dates << s
      end
      leave_identifier = Time.now.getutc.to_s + "__" + check_dates.length.to_s + "__" + current_user.id.to_s
      if check_dates.uniq.length != check_dates.length
        flash.alert = "Two leaves cannot have the same date"
        add_breadcrumb('Leaves', dashboard_empleave_list_path)
        add_breadcrumb('New leave')
        render :action => 'new' 
        return
      end
      new_leave_params_array[:start_time].each do |s| 
        if !s.blank?
          @records << Empleave.new(:start_time => s, :attendee_id => current_user.id, :requestee_id => current_user.id,
          :leave_identifier => leave_identifier, :description => new_leave_params_array[:description]) 
        end
      end
      half_days = new_leave_params_array[:half_day].join("").gsub("01", "1").split("")
      half_day_fors = []
      half_days.each_with_index do |half_day, index|
        if half_day == "1"
          half_day_fors << new_leave_params_array[:half_day_for][index]
        else
          half_day_fors << nil
        end
      end
      @records.each_with_index do |value,index|
        if half_days[index].present?
          value.half_day = half_days[index]
        end
        if half_day_fors[index].present?
          value.half_day_for = half_day_fors[index]
        end
        if value.valid?
          result = value.save
        else 
          flash.now[:alert] = value.errors.full_messages[0]
          add_breadcrumb('Leaves', dashboard_empleave_list_path)
          add_breadcrumb('New leave')
          render :action => 'new' 
          return
        end
      end
      @current_year = Date.today.year
      @leavecounter = Leavecounter.where(:user_id => current_user.id, :year => @current_year).first_or_create
      @team_member = TeamMember.find_by(:user_id => current_user.id)
      if !@team_member.blank?
        @team_member = @team_member
        @team = Team.where(:id => @team_member.team_id).first
        if !@team.blank?
          @program_manager = User.find_by(:id => @team.project_manager_id)
          if !@program_manager.blank?
            @leave_user = User.find(current_user.id)
            leaves_used = @leavecounter.leaves
            if @leavecounter.leaves == nil 
              leaves_used = 0
            end
          end
        end
      end
      flash.notice = "Leave created successfully" if result.present?
      redirect_to :action => 'list'
    end
    
    def edit
      @empleave = Empleave.find(params[:id])
      # @users = User.where(:is_admin => false)
      @users = User.where(:is_admin => false, :archived => false)
      add_breadcrumb('Leaves', dashboard_empleave_list_path)
      add_breadcrumb('Edit leave')
    end

    def update
        @empleave = Empleave.find(params[:id])
        @users = User.where(:archived => false)
        if @empleave.approved == true
            flash.alert = "An approved leave cannot be updated"
            add_breadcrumb('Leaves', dashboard_empleave_list_path)
            add_breadcrumb('New leave')
            redirect_back(fallback_location: root_path)
        else
          leave_params = params[:empleave]

          if leave_params[:ids].blank?
            flash.notice = "Leave deleted successfully"
            redirect_to :action => 'list'
            destroyed_leaves = Empleave.where(leave_identifier: @empleave.leave_identifier)

            destroyed_leaves.each do |leave|
              leave.destroy
            end
            return
          else
            @records = []
            leave_params[:ids].each do |leave|
              @records << Empleave.find_by(id: leave)
            end
            destroyed_leaves = Empleave.where(leave_identifier: @empleave.leave_identifier) - @records
            destroyed_leaves.each do |leave|
              leave.destroy
            end
            leave_params[:half_day] = leave_params[:half_day].join("").gsub("01", "1").split("")
            half_day_fors = []
            leave_params[:half_day].each_with_index do |half_day, index|
              if half_day == "1"
                half_day_fors << leave_params[:half_day_for][index]
              else
                half_day_fors << nil
              end
            end
            if leave_params[:start_time].detect{ |e| leave_params[:start_time].count(e) > 1 }.present?
              flash.alert = "Leave dates should not be duplicate."
              add_breadcrumb('Leaves', dashboard_empleave_list_path)
              add_breadcrumb('Edit leave')
              render :action => 'edit'
              return
            end
            @records.each_with_index do |leave, index|
              leave.update(start_time: leave_params[:start_time][index].to_date, half_day: leave_params[:half_day][index] == "0" ? false : true, description: leave_params[:description], half_day_for: half_day_fors[index] )
            end
            id_count = leave_params[:ids].count
            leave_params[:start_time] = leave_params[:start_time].drop(id_count)
            leave_params[:half_day] = leave_params[:half_day].drop(id_count)
            half_day_fors = half_day_fors.drop(id_count)
            leave_params[:start_time].each_with_index do |leave, index|
              new_leave = Empleave.create!(:start_time => leave.to_date, :requestee_id => current_user.id,
              :attendee_id => current_user.id, :leave_identifier => @empleave.leave_identifier, :description => leave_params[:description],
              :half_day => leave_params[:half_day][index] == "0" ? false : true, :half_day_for => half_day_fors[index])
            end

            if @empleave.errors.blank?
              flash.notice = "Leave updated successfully"
              redirect_to :action => 'list'
            else
                flash.now[:alert] = @empleave.errors.full_messages[0]
                add_breadcrumb('Leaves', dashboard_empleave_list_path)
                add_breadcrumb('Edit leave')
                render :action => 'edit'
            end
          end
        end
    end

    def new_leave_params_array
        params.require(:empleave).permit(:description, :start_time => [], :half_day => [], :half_day_for => [], :ids => [])
    end

    def new_leave_params
        params.require(:empleave).permit(:requestee_id, :start_time => [], :half_day => [], :half_day_for => [], :ids => [])
    end 

    def leave_params
        if current_user.role? :employee
            params.require(:empleave).permit(:description, :approved, :approval_date, :half_day => [], :half_day_for => [], :start_time => [], :ids => [])
        else
            params.require(:empleave).permit(:description, :approved, :approval_date, :requestee_id, :half_day => [], :half_day_for => [], :start_time => [], :ids => [])
        end
    end
    def approve
        if current_user.role? :employee
            flash.alert = "Action forbidden"
            redirect_back(fallback_location: root_path)
        else
            @emp_leave = Empleave.find(params[:id])
            if !@emp_leave.approval_date.nil?
                flash.alert = "Leave already approved"
                redirect_back(fallback_location: root_path)
            else
              leave_details = Empleave.where(leave_identifier: @emp_leave.leave_identifier)
              leave_details.each do |leave|
                leave.approved = true
                leave.approval_date = Date.today
                leave.rejection_date = nil
                @current_year = Date.today.year
                @leavecounter = Leavecounter.where(:user_id => leave.requestee_id, :year => @current_year).first_or_create
                if @leavecounter.nil?
                    if leave.half_day == true
                        @leavecounter_new = Leavecounter.create(:leaves => 0.5, :user_id => leave.requestee_id, :year => @current_year)
                    else
                        @leavecounter_new = Leavecounter.create(:leaves => 1, :user_id => leave.requestee_id, :year => @current_year)
                    end
                else
                    if leave.half_day == true
                        @leavecounter.increment(:leaves, 0.5)
                    else
                        @leavecounter.increment(:leaves, 1)
                    end
                    @leavecounter.save
                end
                leave.save
              end
              @user = User.find(@emp_leave.requestee_id)
              LeaveStatusMailer.leave_approved_mail(@user.email, @user.first_name, @emp_leave.start_time, @emp_leave.half_day)
              flash.notice = "Leave approved"
              redirect_to :action => 'show' ,:id => @user.id
            end
        end
    end 

    def destroy
        if current_user.role? :employee
            flash.alert = "Action forbidden"
            redirect_back(fallback_location: root_path)
        else
            @empleave = Empleave.find(params[:id])
            if !@empleave.rejection_date.nil?
                flash.alert = "Leave already rejected"
                redirect_back(fallback_location: root_path)
            else
              leave_details = Empleave.where(leave_identifier: @empleave.leave_identifier)
              leave_details.each do |leave|
                leave.approved = false
                leave.approval_date = nil
                leave.rejection_date = Date.today
                leave.save
                @current_year = Date.today.year
                @leavecounter = Leavecounter.where(:user_id => leave.requestee_id, :year => @current_year).first
                if !@leavecounter.nil?
                    if leave.half_day == true
                        @leavecounter.decrement(:leaves, 0.5)
                    else
                        @leavecounter.decrement(:leaves, 1)
                    end
                    @leavecounter.save
                end
              end

                @user = User.find(@empleave.requestee_id)
                LeaveStatusMailer.leave_rejected_mail(@user.email, @user.first_name, @empleave.start_time, @empleave.half_day)
                flash.alert = "Leave rejected"
                redirect_to :action => 'show' ,:id => @user.id
            end
        end
    end

    def dynamic_add_leave
        respond_to do |format|
          format.js
        end
      end

    def list
      # puts "IN LIST SAD SADAS"
      # @page = params.fetch(:page,0).to_i
      # puts @page
      # puts "PAGE COUNT --------"
      own_leaves = Empleave.where(:requestee_id => current_user.id, :wfh => false).order("updated_at DESC").page params[:page]
      manager_leaves = []
      user_ids = []
      if current_user.role? :program_manager
        team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
        team_member_ids = TeamMember.where(team_id: team_ids)
        user_ids << User.where(:is_admin => false, :archived => false, id: team_ids).pluck(:id)
        manager_leaves = Empleave.where(requestee_id: user_ids, notified: true, :wfh => false).order("updated_at DESC").page params[:page]
        # @emp_leaves = Kaminari.paginate_array(@emp_leaves_array).page(params[:page]).per(10)          
      end
      leaves = manager_leaves + own_leaves
      leaves = leaves.group_by(&:leave_identifier).values
      @emp_leaves = Kaminari.paginate_array(leaves).page(params[:page]).per(10)
      
      # @emp_leaves = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
      # @emp_leaves = @query
      # puts @emp_leaves.count
      # @last_page = @query.count / RECORD_PER_PAGE
      # if !(@query.count <= RECORD_PER_PAGE)
      #     @next_flag = true
      # end
      # @last_page = @query.count / RECORD_PER_PAGE
      # # respond_to do |format|
      # #     format.html
      # #     format.js {render 'list.js.erb'}
      # # end
      # puts "QUERY COUNT???"
      # puts @query.count 
      # if !(@query.count <= RECORD_PER_PAGE)
      #     @next_flag = true
      #     puts "NEXT FLAG"
      # end
      add_breadcrumb('My Leaves')
    end

    def leavecounters
      return link_jump() if !helpers.access_controller(session[:user_id])
      #@page = params.fetch(:page,0).to_i
      if current_user.role? :superadmin or current_user.role? :admin
        @leavecounters = Leavecounter.all.page params[:page]
      elsif current_user.role? :program_manager
        manager_leaves = []
        team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
        team_member_ids = TeamMember.where(team_id: team_ids).pluck(:user_id)
        user_ids = User.where(:is_admin => false, :archived => false, id: team_member_ids).pluck(:id)
        manager_leaves = Leavecounter.where(user_id: user_ids).page params[:page]
        @leavecounters = manager_leaves
      else
        @leavecounters = Leavecounter.where(:user_id => current_user.id).page params[:page]
      end
      # @leavecounters = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
      # @last_page = @query.count / RECORD_PER_PAGE
      # if !(@query.count <= RECORD_PER_PAGE)
      #     @next_flag = true
      # end
      add_breadcrumb('Leave Requests')
    end

    def show
      return link_jump() if !helpers.access_controller(session[:user_id])
      # manager_leaves = []
      # user_ids = [current_user.id]
      # if current_user.role? :program_manager
      #   team_ids = Team.where(:project_manager_id => current_user.id).pluck(:id)
      #   team_member_ids = TeamMember.where(team_id: team_ids)
      #   user_ids << User.where(:is_admin => false, :archived => false, id: team_ids).pluck(:id)
      #   manager_leaves = Empleave.where(requestee_id: user_ids, notified: true).page params[:page]
      #   @emp_leaves = Kaminari.paginate_array(@emp_leaves_array).page(params[:page]).per(10) 
      leaves = Empleave.where(:requestee_id => params[:id]).order("updated_at DESC")
      leaves = leaves.group_by(&:leave_identifier).values
      @emp_leaves = Kaminari.paginate_array(leaves).page(params[:page]).per(10)
      # @page = params.fetch(:page,0).to_i
      # @emp_leaves = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
      # @last_page = @query.count / RECORD_PER_PAGE
      # if !(@query.count <= RECORD_PER_PAGE)
      #     @next_flag = true
      # end
      add_breadcrumb('Leave requests',dashboard_empleave_counter_path)
      add_breadcrumb('View requests')

    end

    def employee_leave_show
      @new_show_leaves = Empleave.where(:requestee_id => params[:id])

    end
       
    def viewreq
        @emp_leave = Empleave.find(params[:id])
        add_breadcrumb('Leave requests')   
    end

    def delete_leave
      @empleave = Empleave.find(params[:id])
      if @empleave.notified == false
        leaves = Empleave.where(leave_identifier: @empleave.leave_identifier)
        result = leaves.destroy_all
        flash.notice = "Leave deleted successfuly." if result.present?
        flash.alert = "Something went wrong." if result.blank?
        redirect_to :action => 'list'
      else
        flash.alert = "Notified leave cannot be deleted."
        redirect_to :action => 'list'
      end
    end

    def cancel_leave
      @empleave = Empleave.find(params[:id])
      @team_member = TeamMember.find_by(:user_id => current_user.id)
      @team = Team.find_by(:id => @team_member.team_id)
      @program_manager = User.find_by(:id => @team.project_manager_id)
      if @empleave.cancelled == true
        flash.alert = "Leave is already cancelled."
        redirect_to :action => 'list'
      else
        leaves = Empleave.where(leave_identifier: @empleave.leave_identifier)
        leaves.map {|l| l.start_time}.each do |leave_date|
          if leave_date < Date.today
            flash.alert = "Leave is already taken. Can not cancel a leave."
            return
          end
        end
        @leave_user = User.find(current_user.id)
        leaves_canceled = leaves.update_all(cancelled: true)
        LeaveStatusMailer.leave_canceled(@program_manager.email, @program_manager.first_name, @leave_user.full_name)
        flash.notice = "Leave cancelled successfuly." if leaves_canceled.present?
        flash.alert = "Something went wrong." if leaves_canceled.blank?
        redirect_to :action => 'list'
      end
    end

    def notify_leave
      @empleave = Empleave.find(params[:id])
      @leave_user = User.find(@empleave.requestee_id)
      @team_member = TeamMember.find_by(:user_id => current_user.id)
      if @team_member.nil? or @team_member.blank?
        flash.alert = "Employee has no program manager"
        redirect_to :action => 'list' and return
      end
      @team = Team.find_by(:id => @team_member.team_id)
      @program_manager = User.find_by(:id => @team.project_manager_id)
      @leavecounter = Leavecounter.where(:user_id => current_user.id, :year => Date.today.year).first_or_create
      leaves_used = @leavecounter.leaves
      if @empleave.notified == true
        flash.alert = "Leave is already notified to manager."
        redirect_to :action => 'list'
      else
        leaves = Empleave.where(leave_identifier: @empleave.leave_identifier)
        result = leaves.update_all(notified: true)
        LeaveStatusMailer.leave_requested(@program_manager.email, @program_manager.first_name, @leave_user.full_name, leaves_used)
        flash.notice = "Leave notified successfuly." if result.present?
        flash.alert = "Something went wrong." if result.blank?
        redirect_to :action => 'list'
      end
    end
end
