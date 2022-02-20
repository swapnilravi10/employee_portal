class ApplicationController < ActionController::Base
    before_action :set_breadcrumbs
    
    require "browser"
    # protect_from_forgery with: :exception 

    # RECORD_PER_PAGE = 10
    # @next_flag = false

    browser = Browser.new("Chrome")

    def add_breadcrumb(label,path=nil)
        @breadcrumbs << {
            label: label,
            path: path
        }
    end

    def set_breadcrumbs
        @breadcrumbs = []
    end

    def current_user
        User.where(id:session[:user_id]).first
    end
    helper_method :current_user 

    def link_jump
        return render :file => "#{Rails.root}/public/403.html", layout: false , :status => 403
    end
end
