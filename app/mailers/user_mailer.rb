class UserMailer < ActionMailer::Base
  default :from => "DocIT@localhost.com"
  
  def send_registration_link(user)
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end
end
