class Dashboard::ProjectTeamsController < ApplicationController

  def create
    team_params = params[:project_team]
    project_id = team_params[:project_id][0]
    project_members = ProjectTeam.where(project_id: project_id)
    if team_params[:user_id].present?
      updated_project_members = []
      team_params[:user_id].each_with_index do |member, index|
        updated_project_members << {:project_id => project_id.to_i, :user_id => member.to_i, :designation => team_params[:designation][index],
        :project_profile => team_params[:project_profile][index]}
      end
      destroyed_members = project_members - updated_project_members
      destroyed_members.each do |member|
        member.destroy
      end
      updated_project_members.each do |member|
        project_member = ProjectTeam.find_by(project_id: member[:project_id], user_id: member[:user_id])
        if project_member.present?
          project_member.update(designation: member[:designation], project_profile: member[:project_profile])
        else
          ProjectTeam.create(project_id: member[:project_id], user_id: member[:user_id],
          designation: member[:designation], project_profile: member[:project_profile])
        end
      end
    else
      project_members.destroy_all
    end
    flash.notice = "Project team updated successfully." 
    add_breadcrumb('Projects', dashboard_project_list_path)
    redirect_to :action => 'list', :controller => "dashboard/project"
  end

  def project_teams
    return link_jump() if !helpers.access_controller(session[:user_id])
    @project = Project.find_by(id: params[:id])
    @users = User.where(archived: false)
    @project_members = ProjectTeam.where(project_id: @project.id)
    add_breadcrumb('Projects', dashboard_project_list_path)
    add_breadcrumb('Project Team')
  end

  def project_team_params
    params.require(:project_team).permit(:project_id => [], :project_profile => [], :designation => [],:user_id => [])
  end

  def add_member
    @users = User.where(archived: false)
    respond_to do |format|
      format.js
    end
  end
end
