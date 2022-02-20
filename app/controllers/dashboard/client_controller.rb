class Dashboard::ClientController < ApplicationController


    def index
        redirect_to :action => 'list'
    end

    def list
        return link_jump() if !helpers.access_controller(session[:user_id])
        # @page = params.fetch(:page,0).to_i
        @clients = Client.all.order('first_name ASC').page params[:page]
        # @clients = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
        # @last_page = @query.count / RECORD_PER_PAGE
        # respond_to do |format|
        #     format.html
        #     format.js {render 'list.js.erb'}
        # end
        # if !(@query.count <= RECORD_PER_PAGE)
        #     @next_flag = true
        # end
        add_breadcrumb('Clients')
    end

    def new
        return link_jump() if !helpers.access_controller(session[:user_id])
        @client = Client.new
        add_breadcrumb('Clients', dashboard_client_list_path)
        add_breadcrumb('New client')
    end

    def create
        @client = Client.new(new_client_params)
        if @client.valid?
            @client.save
            flash_notice = "Client added successfully"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @client.errors.full_messages[0]
            add_breadcrumb('Clients', dashboard_client_list_path)
            add_breadcrumb('New client')
            render :action => 'new' 
        end
    end
    def new_client_params
        params.require(:client).permit(:first_name, :last_name, :email, :company_name, :phone_number, :country, :company_email, :company_registration_number)
    end

    def edit
        return link_jump() if !helpers.access_controller(session[:user_id])
        @client = Client.find(params[:id])
        add_breadcrumb('Clients', dashboard_client_list_path)
        add_breadcrumb('Edit client')
    end

    def update
        @client = Client.find(params[:id])
        if @client.update(client_params) 
            flash_notice = "Client updated successfully"
            redirect_to :action => 'list'
        else
            flash.now[:alert] = @client.errors.full_messages[0]
            add_breadcrumb('Clients', dashboard_client_list_path)
            add_breadcrumb('Edit client')
            render :action => 'edit'
        end
    end
    def client_params
        params.require(:client).permit(:first_name, :last_name, :email, :company_name, :phone_number, :country, :company_email, :company_registration_number)
    end  

    def destroy
        Client.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

end
