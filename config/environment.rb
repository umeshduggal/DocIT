# Load the rails application
require File.expand_path('../application', __FILE__)
#setting for send email notification by action mailer
ActionMailer::Base.delivery_method = :sendmail 
ActionMailer::Base.sendmail_settings = { :location => '/usr/sbin/sendmail', :arguments => '-i -t' } 
ActionMailer::Base.perform_deliveries = true 
ActionMailer::Base.raise_delivery_errors = true   
# Initialize the rails application
DocIT::Application.initialize!
