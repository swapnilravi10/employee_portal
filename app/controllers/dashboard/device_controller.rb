class Dashboard::DeviceController < ApplicationController


    def list
        return link_jump() if !helpers.access_controller(session[:user_id])
        @devices = Device.all.order('name ASC').page params[:page]
        @users = User.all
        add_breadcrumb('Devices')
    end

    def new
        return link_jump() if !helpers.access_controller(session[:user_id])
        @device = Device.new
        add_breadcrumb('Devices', dashboard_device_list_path)
        add_breadcrumb('New device')
    end

    def create
        @device = Device.new(new_device_params)
        if @device.valid?  
            if current_user.role? :superadmin or current_user.role? :admin
                @device.save
                flash_notice = "Device added successfully"
                redirect_to :action => 'list'
            else
                flash.now[:alert] = @device.errors.full_messages[0]
                add_breadcrumb('Devices', dashboard_device_list_path)
                add_breadcrumb('New device')
                render :action => 'new' 
            end
        else
            flash.alert = "You are not authorized to create device"
            add_breadcrumb('Devices', dashboard_device_list_path)
        end
    end

    def new_device_params 
        params.require(:device).permit(:name, :device_type_id, :description)
    end

    def edit
        return link_jump() if !helpers.access_controller(session[:user_id])
        @device = Device.find(params[:id])
        add_breadcrumb('Devices', dashboard_device_list_path)
        add_breadcrumb('Edit device')
    end

    def update
        @device = Device.find(params[:id])
        if @device.update(device_params)
            if current_user.role? :superadmin or current_user.role? :admin
                flash_notice = "Device updated successfully"
                redirect_to :action => 'list'
            else
                flash.now[:alert] = @device.errors.full_messages[0]
                add_breadcrumb('Devices', dashboard_device_list_path)
                add_breadcrumb('Edit device')
                render :action => 'edit'
            end
        else
            flash.alert = "You are not authorized to update devices for other employees"
            add_breadcrumb('Devices', dashboard_device_list_path)
        end
    end

    def device_params
        params.require(:device).permit(:name, :device_type_id, :description)
    end

    def destroy
        Device.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

    def assign_device
        device = Device.find(params[:device_id].to_i)
        user = User.find(params[:device][:assigned_to].to_i)
        if user.archived == false
            device.update!(assigned_to: user.id)
            flash.notice = "Device assigned successfully."
            redirect_to :action => 'list'
        else
            flash.notice = "Something went wrong."
            redirect_to :action => 'list'
        end
    end

    def unassign_device
        @device = Device.find(params[:id])
        @device.assigned_to = nil
        @device.save
        flash.notice = "Device unassigned successfully."
        redirect_to :action => 'list'
    end
end
