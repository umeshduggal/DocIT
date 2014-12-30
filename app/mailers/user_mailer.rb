class UserMailer < ActionMailer::Base
  default :from => "DocIt@docitamerica.com",
          :reply_to => "help@docitamerica.com"
  
  def send_registration_link(user, to, content_type = 'text/html')
    @user = user
    @email = to.email
    @id = to.id
    if User.find_by_email(to.email)
      @registered = true
    else
      @registered = false
    end
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
  
  def send_feedback(to, params, content_type = 'text/html')
    @to = to
    @params = params
    @content_type = content_type
    mail(:to => "#{to}", :subject => params[:subject], template_path: 'mailer', template_name: 'feedback_form')
  end
    
  def send_call_log(params, content_type = 'text/html')
    @params = params
    @content_type = content_type
    @user = User.find_by_email(params[:email])
    mail(:to => "#{params[:email]}", :subject => "Call Log Detail", template_path: 'mailer', template_name: 'call_log_detail')
  end
  
end
