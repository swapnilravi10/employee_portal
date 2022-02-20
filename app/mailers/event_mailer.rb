class EventMailer < ApplicationMailer
    default from: 'swapnil.ravi01@gmail.com'

    def self.send_request(event)
        @users = User.connection.select_values(User.select("email").where(:archived => false).to_sql)
        
        @users.each do |email|
          event_greeting(email,event).deliver_now
          
        end
      end
    
      def event_greeting(email, event)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        @event = event
    
        mail(to: email, subject: "Greetings for #{@event.event_name}")
    
      end

end
