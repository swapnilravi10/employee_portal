module ApplicationHelper

    def yes_or_no(bool)
        if bool == true
            return "Yes"
        else
            return "No"
        end
    end

    def access_controller(current_user)
        user = User.find(current_user)
        request_url = (request.original_url).to_s
        path = request_url.split("/")[-2] + "/" + request_url.split("/")[-1]
        request_id = request_url.split("/")[-1]
        
        if user.role? :superadmin
            return true

        elsif user.role? :program_manager  
            if path == "empleave/leavecounter"
                return true
            else
                team = Team.find_by(:project_manager_id => user.id)
                team_member = TeamMember.find_by(:team_id => team.id, :user_id => request_id)
                if !team_member.blank?
                    return true
                end
            end
        elsif user.role? :admin
            all_paths = ["employee/list","employee/new","dashboard/setup", "setup/designation","setup/device_type" ,"empleave/leavecounter"]
            if all_paths.include? path or (request_url.split("/")[-3] == "employee" and request_url.split("/")[-1] == "edit")\
                or request_url.split("/")[-2] == "designation" or request_url.split("/")[-2] == "device_type"\
                or request_url.split("/")[-2] == "empleave"
                return true
            end
        else 
            return false
        end
    end

    def access_document(current_user, access_user)
        request_url = (request.original_url).to_s
        path = request_url.split("/")[-2]
        user = User.find(current_user)
        if user.role? :superadmin or current_user.to_i == access_user.to_i
            return true
        elsif user.role? :admin
            if path == "employee"
                return true
            end
        else 
            return false
        end
    end

    def current_request?(*requests)
        return true if requests.include?({
          controller: controller.controller_name,
          action: controller.action_name
        })
        false
      end
      
end
