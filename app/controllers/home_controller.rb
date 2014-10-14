# To change this template, choose Tools | Templates
# and open the template in the editor.

class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  
  # base URL of this application
  BASE_URL = "http://b65f751.ngrok.com/home"
  def index
    
  end
  
  def number_verification
    @user = User.where(id: params[:user_id]).first
    verified = @user.verification params[:verification_code]
    if verified
      flash[:notice] = 'Mobile Number verified sucessfully.'
    else
      flash[:error] = 'Verification code is not valid.'
    end
    redirect_to root_url
  end
  
  
  
  
  def call_logs
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
    calls = client.account.calls.list
    begin
      calls.each do |call|
        puts call.sid + "\t" + call.from + "\t" + call.to
      end
      calls = calls.next_page
    end while not calls.empty?
    render :nothing
  end

  def hello_email
    to = IntendedRecipient.last
    UserMailer.send_registration_link(User.last,to).deliver
    render :nothing => true
  end
  
end
