class ArchiveUser
    include Sidekiq::Worker
    
    def perform(*args)
        date = Date.today
        @users = User.where(:archival_date => date)
        @users.each do |u|
            u.archived = true
            u.save
        end
    end

end