class UserMailer < ActionMailer::Base
  default :from => "Docit@gmail.com"
  
  def send_registration_link(user, to, content_type = 'text/html')
    @user = user
    @email = to.email
    @id = to.id
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    @content_type = content_type
    mail(:to => "#{@email}", :subject => "Invitation for Registration", template_path: 'guest_registrations/mailer', template_name: 'registration_instruction')
  end
  
  def send_billing_summary(user, to, datetime_cont, content_type = 'text/html')
    @user = user
    @to = to
    #BillingSummary.where("created_at >= ?", Time.zone.now.beginning_of_day)
    @call_logs = user.call_logs.includes(:billing_summary).where("billing_summaries.datetime_constant= ?", datetime_cont).order("call_logs.updated_at desc")
    @email = to.email
    @id = to.id
    @content_type = content_type
    unless @call_logs.blank?
      mail(:to => "#{@email}", :subject => "Billing Summary", template_path: 'mailer', template_name: 'call_summary')
    end 
  end
  
#  
#  def metrofax_email_notification(fax, status, content_type = 'text/html')
#    @content_type        = content_type
#    @subject             = fax.subject
#    @recipients          = fax.from
#    @from                = fax.to
#    @sent_on             = Time.now
#    #@body                = {:body => fax, :status => status }
#    @body                = fax
#    @status              = status
#    mail(to: @recipients, subject: @subject, template_path: 'message_sender', template_name: 'metrofax_email_notification') 
#  end
end
