class UserMailer < ActionMailer::Base
  default :from => "DocIt@gmail.com"
  
  def send_registration_link(user, to, content_type = 'text/html')
    @user = user
    @email = to.email
    @id = to.id
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    @content_type = content_type
    mail(:to => "#{@email}", :subject => "Invitation for Registration", template_path: 'guest_registrations/mailer', template_name: 'registration_instruction')
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
