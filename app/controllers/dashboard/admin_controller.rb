class Dashboard::AdminController < ApplicationController

    protect_from_forgery with: :null_session
    
    def index
        @admins = User.where(:is_admin => true).count
        @all_employees = User.where(:archived => false).order('first_name ASC')
        @employees = @all_employees.count
        @teams = Team.all.count
        @clients = Client.all.count
        @projects = Project.all.count
        @holidays = Event.where(:holiday => true).count
        @user_status = Userstatus.find_by(:user_id => session[:user_id])
        @status = Status.all
        @user = User.find(session[:user_id])
        @posts = Post.order("created_at DESC")
        @current_user = User.find(session[:user_id])
        respond_to do |format|
            format.html
            format.js {render 'status_update.js.erb'}
        end
    end

    def update_photo
       user = User.find(params[:id])
       user.avatar.attach(params[:avatar])
       redirect_to :action => 'index'
    end

    def list
        @page = params.fetch(:page,0).to_i
        @query = User.where(:is_admin => true).order('first_name ASC')
        @admins = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
        @last_page = @query.count / RECORD_PER_PAGE
        if !(@query.count <= RECORD_PER_PAGE)
            @next_flag = true
        end
        add_breadcrumb('Admin list')
    end

    def edit
        @admin = User.find(params[:id])
        @roles = Role.where.not(:name => "employee")
        add_breadcrumb('Admin list', dashboard_admin_list_path)
        add_breadcrumb('Edit admin')
    end

    def update
        @admin = User.find(params[:id])
        @roles = Role.where.not(:name => "employee")
        if user_params[:password].blank?
            user_params.delete(:password)
        end
        if @admin.update(user_params.except(:role_id))   
            @assignment = Assignment.find_by(:user_id => @admin.id)
            if !@assignment.nil?
                @assignment.role_id = user_params[:role_id]
                @assignment.save
            end
            flash.notice = "User updated successfully"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @admin.errors.full_messages[0]
            add_breadcrumb('Admin list', dashboard_admin_list_path)
            add_breadcrumb('Edit admin')
            render :action => 'edit'
        end
    end
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :role_id)
    end
    
    def destroy
        User.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

    def new
        @admin = User.new
        @roles = Role.where.not(:name => "employee")
        add_breadcrumb('Admin list', dashboard_admin_list_path)
        add_breadcrumb('New admin')
    end

    def create
        @admin = User.new(new_user_params)
        @admin.is_admin = true
        @roles = Role.where.not(:name => "employee")
        if @admin.valid?
            @admin.save
            @assignment = Assignment.new(:role_id => new_role[:id].to_i, :user_id => @admin.id)
            if @assignment.valid?
                @assignment.save
                flash.notice = "Successfully added new " + @assignment.role.name.to_s
                redirect_to :action => 'list'
            else
                flash.now[:alert] = @admin.errors.full_messages[0]
                add_breadcrumb('Admin list', dashboard_admin_list_path)
                add_breadcrumb('New admin')
                redirect_back(fallback_location: root_path)
            end
        else
            flash.now[:alert] = @admin.errors.full_messages[0]
            add_breadcrumb('Admin list', dashboard_admin_list_path)
            add_breadcrumb('New admin')
            render :action => 'new'
        end
    end
    def new_user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone_number)
    end
    def new_role
        params.require(:role).permit(:id)
    end


    def status_update
        user = User.find(params[:user_id])
        @user_status = Userstatus.find_or_create_by(:user_id => params[:user_id])
        @user_status.status_id = params[:status_id]
        @user_status.save
        @all_employees = User.where(:archived => false).order('first_name ASC')
        session[:user_id] = @user_status.user_id
        respond_to do |format|
            format.js {render 'status_update.js.erb'}
        end
    end

    def public_profile
        @user = User.find(params[:id])
        @user_status = Userstatus.find_by(:user_id => params[:id])
        @posts = Post.where(:user_id => params[:id]).order('created_at DESC')
    end

end
