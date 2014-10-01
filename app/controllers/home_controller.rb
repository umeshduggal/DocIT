# To change this template, choose Tools | Templates
# and open the template in the editor.

class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index,:reminder, :directions,:call_status]
  
  # base URL of this application
  BASE_URL = "http://79be432f.ngrok.com/home"
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
  
  
  # Use the Twilio REST API to initiate an outgoing call
  def makecall
    if !params['number']
      redirect_to :action => '.', 'msg' => 'Invalid phone number'
      return
    end
 
    # parameters sent to Twilio REST API
    data = {
      :from => TWILIO_CONFIG['from'],
      :to => params['number'],
      :record => true,
      :url => BASE_URL + '/patient_call?user_email=umeshduggal1@gmail.com&user_token=vKKATQzx6ceHb-NzS9bm',
      :StatusCallback => BASE_URL + '/call_status?user_email=umeshduggal1@gmail.com&user_token=vKKATQzx6ceHb-NzS9bm'
    }
    begin
      client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
      client.account.calls.create data
    rescue StandardError => bang
      redirect_to :action => '.', 'msg' => "Error #{bang}"
      return
    end
    flash[:notice] = "Thank you, please hang up, Docit will call you back once your party is reached."
    redirect_to root_url
  end
  
  
  def patient_call
    @post_to = BASE_URL + '/language_selection?user_email=umeshduggal1@gmail.com&user_token=vKKATQzx6ceHb-NzS9bm'
    render :action => "patient_call.xml.builder", :layout => false
  end
  
  def language_selection
    if params['Digits'] == '1'
      @post_to = BASE_URL + '/directions'
      render :action => "language_selection.xml.builder", :layout => false
      return
    end
    redirect_to :action => 'patient_call'
    return
  end
  
  # TwiML response that reads the reminder to the caller and presents a
  # short menu: 1. repeat the msg, 2. directions, 3. goodbye
  def reminder
    @post_to = BASE_URL + '/directions'
    render :action => "reminder.xml.builder", :layout => false
  end

  # TwiML response that inspects the caller's menu choice:
  # - says good bye and hangs up if the caller pressed 3
  # - repeats the menu if caller pressed any other digit besides 2 or 3
  # - says the directions if they pressed 2 and redirect back to menu
  def directions
    if params['Digits'] == '3'
      redirect_to :action => 'goodbye'
      return
    end
 
    if !params['Digits'] or params['Digits'] != '2'
      redirect_to :action => 'reminder'
      return
    end
 
    @redirect_to = BASE_URL + '/reminder'
    render :action => "directions.xml.builder", :layout => false
  end
  
 # TwiML response saying with the goodbye message. Twilio will detect no
  # further commands after the Say and hangup 
  def goodbye
    render :action => "goodbye.xml.builder", :layout => false 
  end
  
  def call_status
    Rails.logger.info "------------------------------------------"
    Rails.logger.info "------------------------------------------"
    Rails.logger.info current_user.inspect
    Rails.logger.info params.inspect
    Rails.logger.info "------------------------------------------"
    Rails.logger.info "------------------------------------------"
    render :nothing => true
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
    
#    mail(:to => "umesh duggal <umeshduggal1@gmail.com>") do |format|
#      format.text { render :text => "This is text!" }
#      format.html { render :text => "<h1>This is HTML</h1>" }
#    end
end
  
end
