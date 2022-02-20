class LogoutUserWorker
  include Sidekiq::Worker

  def perform(*args)
    # Logout users at 11:00PM if not manually logged out
    @users = User.where(logged_in: true)
    for user in @users
      user.logged_in = false
      user.save
      @user_status = Userstatus.find_by(:user_id => user.id)
      @user_status.status_id = 7
      @user_status.save
    end
  end
end
