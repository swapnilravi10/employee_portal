
class NewUserMailer < ApplicationMailer
    default from: 'swapnil.ravi01@gmail.com'
    def self.user_registered(employee,current_user,url)
        send_password_link_new_user(employee,current_user,url).deliver_now
    end
    def send_password_link_new_user(employee,current_user,url)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        mail_content = "<p> Hi #{employee.full_name},</p>&emsp;Welcome to Anveshak. You are successfully added to Anveshak Portal by #{current_user.full_name}. Please use the following link to login:<br><a href=#{url}>Reset Password</a> <br>&emsp;This link will take you to the reset password page. We highly recommend this.<br>&emsp;All the best! Keep working!<br><br>Regards, <br>Anveshak Technologies and Knowledge Solutions, Pune"
        mail_subject = "Account registration successful."
        @mail_subject = mail_subject
        @mail_content = mail_content.html_safe
        subject = "Account registered successfully."
        mail(to: employee.email, :subject => subject, mail_content: @mail_content)
    end
    def send_reset_password_link(employee ,url)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        mail_content = "<p> Hi #{employee.full_name},</p>Please use the following link to reset password: <br><a href=#{url}>Reset Password</a>.<br>All the best! Keep working!<br><br>Regards,<br>Anveshak Technologies and Knowledge Solutions, Pune"
       mail_subject = "Reset Password."
        @mail_subject = mail_subject
        @mail_content = mail_content.html_safe
        subject = "Reset Password."
        mail(to: employee.email, :subject => subject, mail_content: @mail_content)
    end
end

