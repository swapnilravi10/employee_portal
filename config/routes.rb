Rails.application.routes.draw do
  resources :post_attachments
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root :to => redirect('/login')
  get 'login', to: 'login#login'
  get 'register', to: 'login#register'
  post 'create', to: 'login#create'
  post 'login', to: 'login#login_user'
  get 'logout', to: 'login#logout_user'
  get 'dashboard/admin/list', to: 'dashboard/admin#list'
  delete 'dashboard/admin/:id', to: 'dashboard/admin#destroy', as: 'user'   
  get 'dashboard/employee/list', to: 'dashboard/employee#list'
  get 'dashboard/employee/attendance', to: 'dashboard/employee#attendance_list'
  delete 'dashboard/employee/:id', to: 'dashboard/employee#destroy', as: 'employee' 
  get 'dashboard/team/list', to: 'dashboard/team#list'
  delete 'dashboard/team/:id', to: 'dashboard/team#destroy', as: 'team' 
  delete 'dashboard/team/:team_id/delete_member/:id', to: 'dashboard/team#delete_member', as: 'dashboard_team_delete_member'
  get 'dashboard/client/list', to: 'dashboard/client#list'
  delete 'dashboard/client/:id', to: 'dashboard/client#destroy', as: 'client'
  get 'dashboard/project/list', to: 'dashboard/project#list'
  delete 'dashboard/project/:id', to: 'dashboard/project#destroy', as: 'project'
  get 'dashboard/calendar/event/new', to: 'dashboard/calendar#add_event'
  post 'dashboard/calendar/event/create', to: 'dashboard/calendar#create'
  get 'dashboard/calendar/event/list', to: 'dashboard/calendar#list'
  get 'dashboard/calendar/event/edit/:id', to: 'dashboard/calendar#edit'
  patch 'dashboard/calendar/event/edit/:id', to: 'dashboard/calendar#update'
  delete 'dashboard/calendar/event/delete/:id', to: 'dashboard/calendar#destroy', as: 'event'
  get 'dashboard/setup', :to => 'dashboard/setup#index', :as => 'dashboard_setup_index'
  get 'dashboard/setup', to: 'dashboard/setup#edit'
  patch 'dashboard/setup', to: 'dashboard/setup#update'  
  get 'dashboard/payroll', to: 'dashboard/payroll#list'  
  post 'dashboard/payroll/month', to: 'dashboard/payroll#month_payroll'
  # get 'dashboard/payroll/month', to: 'dashboard/payroll#download_payroll'
  get 'dashboard/empleave/list', to: 'dashboard/empleave#list'
  delete 'dashboard/empleave/:id', to: 'dashboard/empleave#destroy', as: 'dashboard_empleave_destroy' 
  delete 'dashboard/empleave/delete_leave/:id', to: 'dashboard/empleave#delete_leave', as: 'dashboard_empleave_delete_leave' 
  put 'dashboard/empleave/cancel_leave/:id', to: 'dashboard/empleave#cancel_leave', as: 'dashboard_empleave_cancel_leave' 
  put 'dashboard/empleave/notify_leave/:id', to: 'dashboard/empleave#notify_leave', as: 'dashboard_empleave_notify_leave' 
  match 'dashboard/empleave/:id/approve', :to => 'dashboard/empleave#approve', :as => 'dashboard_empleave_approve', :via => :post
  match 'dashboard/empleave/:id/delete', :to => 'dashboard/empleave#delete', :as => 'dashboard_empleave_delete', :via => :delete
  get 'dashboard/empleave/leavecounter', :to => 'dashboard/empleave#leavecounters', :as => 'dashboard_empleave_counter'
  get 'dashboard/empleave/show', :to => 'dashboard/empleave#show', :as => 'dashboard_empleave_show'
  get 'dashboard/empleave/:id/viewreq', :to => 'dashboard/empleave#viewreq', :as => 'dashboard_empleave_viewreq'
  get 'dashboard/attendance/user/:id', :to => 'dashboard/setup#list', :as => 'dashboard_attendance_list'
  # get 'dashboard/attendance/:year/user/:id', :to => 'dashboard/setup#byyearuser', as=> 'dashboard_attendance_user'

  get 'dashboard/attendance/fetch', :to => 'dashboard/attendance#index'
  post 'dashboard/attendance/fetch', :to => 'dashboard/attendance#index'
  get 'dashboard/attendance/wfh', :to => 'dashboard/attendance#work_from_home'
  post 'dashboard/attendance/wfh', :to => 'dashboard/attendance#work_from_home'
  get 'dashboard/attendance/wfh/list', :to => 'dashboard/attendance#list_wfh'
  delete 'dashboard/attendance/wfh/:id', to: 'dashboard/attendance#destroy', as: 'dashboard_attendance_destroy'

  match 'dashboard/employee/:id/activate', :to => 'dashboard/employee#activate_emp', :as => 'dashboard_employee_activate', :via => :post
  match 'dashboard/employee/:id/deactivate', :to => 'dashboard/employee#deactivate', :as => 'dashboard_employee_deactivate', :via => :post
  # match 'dashboard/employee/deactivate', :to => 'dashboard/employee#deactivate', :as => 'dashboard_employee_deactivate', :via => :post
  post 'dashboard/employee/deactivate', :to => 'dashboard/employee#deactivate_emp', :as => 'dashboard_employee_deactivate_emp'
  # match 'dashboard/employee/deactivate', :to => 'dashboard/employee#deactivate_emp', :as => 'dashboard_employee_deactivate_emp', :via => get
  get 'dashboard/setup/designation/:id', :to => 'dashboard/setup#edit_designation', :as => 'dashboard_setup_designation_get'
  patch 'dashboard/setup/designation', :to => 'dashboard/setup#update_designation', :as => 'dashboard_setup_designation_update'
  delete 'dashboard/setup/designation', :to => 'dashboard/setup#delete_designation', :as => 'dashboard_setup_designation_delete'
  get 'dashboard/setup/designation', :to => 'dashboard/setup#new_designation', :as => 'dashboard_setup_designation_new'
  post 'dashboard/setup/new/designation', :to => 'dashboard/setup#create_designation', :as => 'dashboard_setup_designation_create'


  get 'dashboard/setup/device_type/:id', :to => 'dashboard/setup#edit_device_type', :as => 'dashboard_setup_device_type_get'
  patch 'dashboard/setup/device_type', :to => 'dashboard/setup#update_device_type', :as => 'dashboard_setup_device_type_update'
  delete 'dashboard/setup/device_type', :to => 'dashboard/setup#delete_device_type', :as => 'dashboard_setup_device_type_delete'
  get 'dashboard/setup/device_type', :to => 'dashboard/setup#new_device_type', :as => 'dashboard_setup_device_type_new'
  post 'dashboard/setup/new/device_type', :to => 'dashboard/setup#create_device_type', :as => 'dashboard_setup_device_type_create'

  get 'dashboard/device/list', to: 'dashboard/device#list'
  delete 'dashboard/device/:id', :to => 'dashboard/device#destroy', :as => 'device'
  get 'dashboard/device/unassign', to: 'dashboard/device#unassign_device'
  post 'dashboard/device/assign', to: 'dashboard/device#assign_device'

  get 'reset/password/:hashid', :to => 'login#reset_password', :as => 'login_reset_password'
  post 'reset/password/process/:hashid', :to => 'login#reset_password_process', :as => 'login_reset_password_process'
  get 'forgot/password', :to => 'login#forgot_password', :as => 'login_forgot_password'
  post 'forgot/password/process', :to => 'login#forgot_password_process', :as => 'login_forgot_password_process'
  get 'dashboard/leave/add-new', :to => 'dashboard/empleave#dynamic_add_leave', :as => 'dashboard_dynamic_add_leave'
  delete 'dashboard/employee/usertech/:id', :to => 'dashboard/employee#destroy_user_tech', :as => 'usertechnology'
  post 'dashboard/admin/update_photo/:id', :to => 'dashboard/admin#update_photo', :as => 'dashboard_admin_update_photo'
  post 'dashboard/admin/status', :to => 'dashboard/admin#status_update'
  post 'dashboard/post/new_post', :to => 'dashboard/post#new_post'
  delete 'dashboard/post/:id', :to => 'dashboard/post#destroy', as: 'post'
  post 'dashboard/post/new_comment', :to => 'dashboard/post#new_comment'
  delete 'dashboard/post/delete_comment/:id', :to => 'dashboard/post#delete_comment', as:'comment'
  post 'dashboard/post/post_like', :to => 'dashboard/post#post_like'
  get 'dashboard/admin/public_profile/:id', :to => 'dashboard/admin#public_profile'
  get 'dashboard/employee/documents/:id', to: 'dashboard/employee#documents' 
  post 'dashboard/employee/upload_document/:id', to: 'dashboard/employee#upload_document'
  post 'dashboard/employee/download_document', to: 'dashboard/employee#download_document'
  post 'dashboard/employee/view_document', to: 'dashboard/employee#view_document'
  post 'dashboard/employee/delete_document', to: 'dashboard/employee#delete_document'
  get 'dashboard/project_team/:id', :to => 'dashboard/project_teams#project_teams'
  get 'dashboard/project_team', :to => 'dashboard/project_teams#add_member', :as => 'dashboard_add_member'

  namespace :dashboard do
    resources :admin, :employee, :client , :empleave, :attendance, :designation, :project, :payroll, :post, :device , :only => [:edit, :index, :update, :create, :new, :show]
  end
  namespace :dashboard do
    resources :team, :only => [:edit, :index, :update, :create, :new] do
      post :team_member
      get :team_member
      post :add_members
    end
  end
  namespace :dashboard do
    resources :calendar, :only => [:index] 
    resources :project_teams, :only => [:create] do
      get :add_member
    end
  end
end
