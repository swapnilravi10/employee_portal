class Dashboard::SetupController < ApplicationController

    def index
        return link_jump() if !helpers.access_controller(session[:user_id])
        @setup = Setup.first
        @designations = Designation.all
        @device_type = DeviceType.all
        respond_to do |format|
            format.html
            format.js {render 'list.js.erb'}
        end
        add_breadcrumb('Global setup')
    end

    def update
        @setup = Setup.find(params[:id])
        @setup.update(setup_params)
        flash.notice = "Yearly leaves updated successfully"
        redirect_to :action => 'index'
    end

    def setup_params
        params.require(:setup).permit(:yearly_leaves)
    end
    def new_designation
        return link_jump() if !helpers.access_controller(session[:user_id])
        @designation = Designation.new
        add_breadcrumb('Global setup', dashboard_setup_index_path)
        add_breadcrumb('Create designation')
    end

    def create_designation
        Designation.all.pluck(:name).each do |d|
            if d.to_s.remove(' ').downcase == new_designation_params[:name].to_s.remove(' ').downcase
                flash.alert = "Designation already exists"
                redirect_to :action => 'new_designation'
                return
            end
        end
        @designation = Designation.create(new_designation_params)
        if @designation.valid?
            @designation.save
            flash.notice = "New designation created successfuly"
            redirect_to :action => 'index'
        else
            flash.now[:alert] = @designation.errors.full_messages[0]
            add_breadcrumb('Global setup', dashboard_setup_index_path)
            add_breadcrumb('Create designation')
            render :action => 'new_designation'
        end
    end
    def new_designation_params
        params.require(:designation).permit(:name)
    end

    def edit_designation
        return link_jump() if !helpers.access_controller(session[:user_id])
        @designation = Designation.find(params[:id])
        add_breadcrumb('Global setup', dashboard_setup_index_path)
        add_breadcrumb('Edit designation')
    end 

    def update_designation
        @designation = Designation.find(params[:id])
        if !@designation.nil? 
            @designation.update(designation_params)
            flash.notice = "Designation updated successfully"
            redirect_to :action => 'index'
        else
            flash.now[:alert] = @designation.errors.full_messages[0]
            add_breadcrumb('Global setup', dashboard_setup_index_path)
            add_breadcrumb('Edit designation')
            render :action => 'edit'
        end
    end

    def delete_designation
        @designation = Designation.find(params[:id])
        @users_with_this_designation = User.where(:designation_id => @designation.id)
        if @users_with_this_designation.blank?
            Designation.find(params[:id]).destroy
            redirect_to :action => 'index'
        else
            flash.alert = "Designation mapped to user(s). Cannot delete this designation."
            redirect_to :action => 'index'
        end
    end

    def designation_params
        params.require(:designation).permit(:name)
    end


    def new_device_type
        return link_jump() if !helpers.access_controller(session[:user_id])
        @device_type = DeviceType.new
        add_breadcrumb('Global setup', dashboard_setup_index_path)
        add_breadcrumb('Create device type')
    end

    def create_device_type
        DeviceType.all.pluck(:device_type).each do |d|
            if d.to_s.remove(' ').downcase == new_device_type_params[:device_type].to_s.remove(' ').downcase
                flash.alert = "Device type already exists"
                redirect_to :action => 'new_device_type'
                return
            end
        end
        @device_type = DeviceType.create(new_device_type_params)
        if @device_type.valid?
            @device_type.save
            flash.notice = "New device type created successfuly"
            redirect_to :action => 'index'
        else
            flash.now[:alert] = @device_type.errors.full_messages[0]
            add_breadcrumb('Global setup', dashboard_setup_index_path)
            add_breadcrumb('Create device type')
            render :action => 'new_device_type'
        end
    end
    def new_device_type_params
        params.require(:device_type).permit(:device_type)
    end

    def edit_device_type
        return link_jump() if !helpers.access_controller(session[:user_id])
        @device_type = DeviceType.find(params[:id])
        add_breadcrumb('Global setup', dashboard_setup_index_path)
        add_breadcrumb('Edit device type')
    end 

    def update_device_type
        @device_type = DeviceType.find(params[:id])
        if !@device_type.nil? 
            @device_type.update(device_type_params)
            flash.notice = "Device type updated successfully"
            redirect_to :action => 'index'
        else
            flash.now[:alert] = @device_type.errors.full_messages[0]
            add_breadcrumb('Global setup', dashboard_setup_index_path)
            add_breadcrumb('Edit device type')
            render :action => 'edit'
        end
    end

    def device_type_params
        params.require(:device_type).permit(:device_type)
    end

    def delete_device_type
        @device_type = DeviceType.find(params[:id]).destroy
        redirect_to :action => 'index'
    end
end
