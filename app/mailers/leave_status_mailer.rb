class LeaveStatusMailer < ApplicationMailer
    default from: 'swapnil.ravi01@gmail.com'

    def self.leave_requested(program_manager_email, program_manager_name, user_name, leaves_used)
        leave_requested_send_mail(program_manager_email, program_manager_name, user_name, leaves_used).deliver_now
    end

    def leave_requested_send_mail(program_manager_email, program_manager_name, user_name, leaves_used)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        # reason = "The reason mentioned for the leave is: <p> \"#{reason}\" </p>"
        # if leave_from == leave_to
        #     leave_from = leave_from.strftime("%d-%m-%Y")
        #     leave_to = leave_to.strftime("%d-%m-%Y")
        #     if half_day == true
        #         mail_content = "<p> Hello #{program_manager_name}, </p> #{user_name} has requested for half day leave on #{leave_from}. #{user_name} has used #{leaves_used} leaves this year."
        #         mail_subject = "#{user_name} has requested for a half day leave."
        #     else
        #         mail_content = "<p> Hello #{program_manager_name}, </p> #{user_name} has requested for leave on #{leave_from}. #{user_name} has used #{leaves_used} leaves this year."
        #         mail_subject = "#{user_name} has requested for leave."
        #     end
        # else   
        #     leave_from = leave_from.strftime("%d-%m-%Y")
        #     leave_to = leave_to.strftime("%d-%m-%Y")
        mail_content = "<p> Hello #{program_manager_name}, </p> #{user_name} has requested for leave."
        mail_subject = "#{user_name} has requested for leave."
        # end
        @mail_subject = mail_subject
        @mail_content = mail_content.html_safe
        # @reason = reason.html_safe
        subject = "#{user_name} has requested for leave."
        mail(to: program_manager_email, :subject => subject, mail_subject: mail_subject, mail_content: mail_content ) 
    end

    def self.leave_canceled(program_manager_email, program_manager_name, user_name)
        leave_canceled_send_mail(program_manager_email, program_manager_name, user_name).deliver_now
    end

    def leave_canceled_send_mail(program_manager_email, program_manager_name, user_name)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        mail_content = "<p> Hello #{program_manager_name}, </p> #{user_name} has canceled leave."
        mail_subject = "#{user_name} has cancelled a leave."
        @mail_subject = mail_subject
        @mail_content = mail_content.html_safe
        subject = "#{user_name} has cancelled a leave"
        mail(to: program_manager_email, :subject => subject, mail_subject: mail_subject, mail_content: mail_content)
    end

    def self.leave_approved_mail(email, user_name, leave_from, half_day)
        leave_approved_send_mail(email, user_name, leave_from, half_day).deliver_now
    end
    def leave_approved_send_mail(email, user_name, leave_from, half_day)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        # if leave_from == leave_to
        leave_from = leave_from.strftime("%d-%m-%Y")
        # leave_to = leave_to.strftime("%d-%m-%Y")
        if half_day == true
            mail_content = "<p> Hello #{user_name}, </p> Your request for half day leave on #{leave_from} has been approved."
            mail_subject = "Half day leave request status update."
        else
            mail_content = "<p> Hello #{user_name}, </p> Your request for leave on #{leave_from} has been approved."
            mail_subject = "Leave request status update."
        end
        # else
        #     leave_from = leave_from.strftime("%d-%m-%Y")
        #     leave_to = leave_to.strftime("%d-%m-%Y")
        #     mail_content = "<p> Hello #{user_name}, </p> Your request for leave from #{leave_from} to #{leave_to} has been approved."
        #     mail_subject = "Leave request status update."
        # end
        @mail_subject = mail_subject
        @mail_content = mail_content.html_safe
        mail(to: email, :subject => "Your leave request has been approved.", mail_subject: mail_subject, mail_content: mail_content)
    end 

    def self.leave_rejected_mail(email, user_name, leave_from, half_day)
        leave_rejected_send_mail(email, user_name, leave_from, half_day).deliver_now
    end
    def leave_rejected_send_mail(email, user_name, leave_from, half_day)
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["full_logo.png"] = File.read("#{Rails.root}/app/assets/images/full_logo.png")
        # if leave_from == leave_to
        leave_from = leave_from.strftime("%d-%m-%Y")
        # leave_to = leave_to.strftime("%d-%m-%Y")
        if half_day == true
            mail_content = "<p> Hello #{user_name}, </p> Your request for half day leave on #{leave_from} has been rejected."
            mail_subject = "Half day leave request status update."
        else
            mail_content = "<p> Hello #{user_name}, </p> Your request for leave on #{leave_from} has been rejected."
            mail_subject = "Leave request status update."
        end
        # else
        #     leave_from = leave_from.strftime("%d-%m-%Y")
        #     leave_to = leave_to.strftime("%d-%m-%Y")
        #     mail_content = "<p> Hello #{user_name}, </p> Your request for leave from #{leave_from} to #{leave_to} has been rejected."
        #     mail_subject = "Leave request status update."
        # end
        @mail_subject = mail_subject
        @mail_content = mail_content.html_safe
        mail(to: email, :subject => "Your leave request has been rejected.", mail_subject: mail_subject, mail_content: mail_content)
    end 
end
