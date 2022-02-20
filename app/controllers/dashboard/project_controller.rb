class Dashboard::ProjectController < ApplicationController

    def index
        redirect_to :action => 'list'
    end

    def list
        return link_jump() if !helpers.access_controller(session[:user_id])
        # @page = params.fetch(:page,0).to_i
        @projects = Project.all.order('name ASC').page params[:page]
        # @projects = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
        # @last_page = @query.count / RECORD_PER_PAGE
        # respond_to do |format|
        #     format.html
        #     format.js {render 'list.js.erb'}
        # end
        # if !(@query.count <= RECORD_PER_PAGE)
        #     @next_flag = true
        # end
        add_breadcrumb('Projects')
    end

    def new
        return link_jump() if !helpers.access_controller(session[:user_id])
        @project = Project.new
        @users = User.where(archived: false)
        @clients = Client.all
        add_breadcrumb('Projects', dashboard_project_list_path)
        add_breadcrumb('New project')
    end

    def create
        @project = Project.new(new_project_params)
        @users = User.where(archived: false)
        @clients = Client.all
        if @project.valid?
            @project.save
            flash.notice = "Project added successfuly"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @project.errors.full_messages[0]
            add_breadcrumb('Projects', dashboard_project_list_path)
            add_breadcrumb('New project')
            render :action => 'new'
        end
    end
    def new_project_params
        params.require(:project).permit(:name, :description, :project_leader_id, :client_id)
    end

    def edit
        return link_jump() if !helpers.access_controller(session[:user_id])
        @project = Project.find(params[:id])
        @users = User.where(archived: false)
        @clients = Client.all
        add_breadcrumb('Projects', dashboard_project_list_path)
        add_breadcrumb('Edit project')
    end

    def update
        @project = Project.find(params[:id])
        @teams = Team.all
        @clients = Client.all
        if @project.update(project_params)
            flash.notice = "Project updated"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @project.errors.full_messages[0] 
            add_breadcrumb('Projects', dashboard_project_list_path)
            add_breadcrumb('Edit project')  
            render :action => 'edit'
        end
    end
    def project_params
        params.require(:project).permit(:name, :description, :project_leader_id, :client_id)
    end


    def destroy
        Project.find(params[:id]).destroy
        redirect_to :action => 'list' 
    end
end
