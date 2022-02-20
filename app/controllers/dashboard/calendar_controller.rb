class Dashboard::CalendarController < ApplicationController

    def index
        start_date = params.fetch(:start_date, Date.today).to_date
        @events = Event.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
        add_breadcrumb('Calendar')
    end

    def list
        return link_jump() if !helpers.access_controller(session[:user_id])
        @page = params.fetch(:page,0).to_i
        @query = Event.all.order('event_name ASC')
        @events = @query.offset(@page * RECORD_PER_PAGE).limit(RECORD_PER_PAGE)
        @last_page = @query.count / RECORD_PER_PAGE
        respond_to do |format|
            format.html
            format.js {render 'list.js.erb'}
        end
        if !(@query.count <= RECORD_PER_PAGE)
            @next_flag = true
        end
        add_breadcrumb('Calendar', dashboard_calendar_index_path)
        add_breadcrumb('Events')
        
    end

    def add_event
        return link_jump() if !helpers.access_controller(session[:user_id])
        @event = Event.new
        add_breadcrumb('Calendar', dashboard_calendar_index_path)
        add_breadcrumb('New event')
    end

    def create
        @event = Event.new(new_event_params)
        if @event.valid?
            @event.save
            redirect_to :action => 'index'
        else
            render :action => 'add_event'
        end
    end
    def new_event_params
        params.require(:event).permit(:event_name, :start_time, :end_time, :holiday)
    end

    def edit
        return link_jump() if !helpers.access_controller(session[:user_id])
        @event = Event.find(params[:id])
        add_breadcrumb('Calendar', dashboard_calendar_index_path)
        add_breadcrumb('Edit event')
    end

    def update
        @event = Event.find(params[:id])
        if @event.update(update_event_params)
            redirect_to :action => 'list'
        else
            render :action => 'edit'
        end
    end
    def update_event_params
        params.require(:event).permit(:event_name, :start_time, :end_time, :holiday)
    end

    def destroy
        Event.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

end
