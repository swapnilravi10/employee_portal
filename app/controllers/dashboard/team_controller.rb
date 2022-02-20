class Dashboard::TeamController < ApplicationController

    def index
        redirect_to :action => 'list'
    end

    def list
        return link_jump() if !helpers.access_controller(session[:user_id])
        @teams = Team.all.order('name ASC').page params[:page]
        # @page = params.fetch(:page,0).to_i
        # @query = Team.all.order('name ASC')
        # @teams = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
        # @last_page = @query.count / RECORD_PER_PAGE
        # respond_to do |format|
        #     format.html
        #     format.js {render 'list.js.erb'}
        # end
        # if !(@query.count <= RECORD_PER_PAGE)
        #     @next_flag = true
        # end
        add_breadcrumb('Teams')
    end
    
    def new
        # if current_user.role? :employee
        return link_jump() if !helpers.access_controller(session[:user_id])
        @team = Team.new
        # @users = User.where(:is_admin => false, :archived => false) 
        @program_manager_role = Role.where(:name => "program_manager").first
        assignment_user_ids = Assignment.where(:role_id => @program_manager_role.id).pluck(:user_id)
        @users = User.where(:is_admin => false, :archived => false).where.not(id: assignment_user_ids)
        @project_managers = User.where(id: assignment_user_ids, archived: false)
        add_breadcrumb('Teams', dashboard_team_list_path)
        add_breadcrumb('New team')
    end

    def create
        @team = Team.new(new_team_params)
        # @users = User.where(:is_admin => false, :archived => false)
        @program_manager_role = Role.where(:name => "program_manager").first
        assignment_user_ids = Assignment.where(:role_id => @program_manager_role.id).pluck(:user_id)
        @users = User.where(:is_admin => false, :archived => false).where.not(id: assignment_user_ids)
        @project_managers = User.where(id: assignment_user_ids, archived: false)
        if @team.valid?
            @team.save
            flash_notice = "Team added successfully"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @team.errors.full_messages[0]
            add_breadcrumb('Teams', dashboard_team_list_path)
            add_breadcrumb('New team')
            render :action => 'new'
        end
    end
    def new_team_params
        params.require(:team).permit(:name, :description, :project_manager_id)
    end
    def new_team_leader
        params.require(:team_leader).permit(:user_id)
    end

    def destroy
        Team.find(params[:id]).delete
        redirect_to :action => 'list'
    end

    def edit
        return link_jump() if !helpers.access_controller(session[:user_id])
        @team = Team.find(params[:id])
        # @users = User.where(:is_admin => false, :archived => false)
        @program_manager_role = Role.where(:name => "program_manager").first
        assignment_user_ids = Assignment.where(:role_id => @program_manager_role.id).pluck(:user_id)
        @users = User.where(:is_admin => false, :archived => false).where.not(id: assignment_user_ids)
        @project_managers = User.where(id: assignment_user_ids, archived: false)
        add_breadcrumb('Teams', dashboard_team_list_path)
        add_breadcrumb('Edit team')
    end

    def update
        @team = Team.find(params[:id])
        # @users = User.where(:is_admin => false, :archived => false)
        @program_manager_role = Role.where(:name => "program_manager").first
        assignment_user_ids = Assignment.where(:role_id => @program_manager_role.id).pluck(:user_id)
        @users = User.where(:is_admin => false, :archived => false).where.not(id: assignment_user_ids)
        @project_managers = User.where(id: assignment_user_ids, archived: false)
        if @team.update(team_params)
            flash.notice = "Team updated successfully"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @team.errors.full_messages[0]
            add_breadcrumb('Teams', dashboard_team_list_path)
            add_breadcrumb('Edit team')
            render :action => 'edit'
        end
    end
    def team_params
        params.require(:team).permit(:name, :description, :project_manager_id)
    end
    def team_leader_params
        params.require(:team_leader).permit(:user_id)
    end

    def team_member
        return link_jump() if !helpers.access_controller(session[:user_id])
        @team = Team.find(params[:team_id]).name
        all_team_members = TeamMember.all
        ids_to_exclude = all_team_members.map {|tm| tm.user_id}
        @team_members = all_team_members.where(:team_id => params[:team_id])
        items_table = Arel::Table.new(:users)
        @users = User.where(items_table[:id].not_in ids_to_exclude).where(:archived => false)
        add_breadcrumb('Teams', dashboard_team_list_path)
        add_breadcrumb('Manage team members')
    end

    def add_members
        for id in team_member_params[:user_id]
            if !id.blank?
                @team_members = TeamMember.new
                @team_members.team_id = params[:team_id]
                @team_members.user_id = id
                @team_members.save
            end
        end
        flash.notice = "Team members added successfully"
        redirect_to :action => 'team_member'
    end
    def team_member_params
        params.require(:team_member).permit(:user_id =>[])
    end

    def delete_member
        TeamMember.find_by(:user_id => params[:id],:team_id => params[:team_id],:is_team_leader => false).destroy
        redirect_to :action => 'team_member'
    end
end
