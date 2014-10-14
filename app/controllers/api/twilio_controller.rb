# To change this template, choose Tools | Templates
# and open the template in the editor.

class Api::TwilioController < ApplicationController
  
  
  # base URL of this application
  BASE_URL = "http://b65f751.ngrok.com/api/twilio"
  # Use the Twilio REST API to initiate an outgoing call
  def makecall
    if !params['number']
      render :status => 401,
        :json => { :success => false,
        :info => 'Invalid phone number or no number suplied.',
        :data => {} }
      return
    end
    attempt = params[:attempt] || "first"
    if params[:call_id]
      call_id  = params[:call_id]
    else
      call_log = current_user.call_logs.create(:patient_mobile_number => params['number'])
      call_id = call_log.id
    end
    # parameters sent to Twilio REST API
    
    data = {
      :from => TWILIO_CONFIG['from'],
      :to => params['number'],
      :url => BASE_URL + "/patient_call?call_id=#{call_id}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}",
      :StatusCallback => BASE_URL + "/call_status?call_id=#{call_id}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&attempt=#{attempt}"
    }
    begin
      client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
      client.account.calls.create data
    rescue StandardError => msg
      render :status => 401,
        :json => { :success => false,
        :info => "Error #{msg}",
        :data => {} }
      return
    end
    render :status => 200,
      :json => { :success => true,
      :info => "Thank you, please hang up, Docit will call you back once your party is reached.",
      :data => { } }
    #flash[:notice] = "Thank you, please hang up, Docit will call you back once your party is reached."
    #redirect_to root_url
  end
  
  
  def patient_call
    @post_to = BASE_URL + "/language_selection?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}"
    render :action => "patient_call.xml.builder", :layout => false
  end
  
  def language_selection
    if params['Digits'] == '1'
      @post_to = BASE_URL + "/patient_identifier?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}"
      render :action => "language_selection.xml.builder", :layout => false
      return
    end
#    redirect_to :action => 'patient_call', :call_id => params[:call_id], :user_email=> params[:user_email],:user_token=> params[:user_token]
#    return
  end
  
  def patient_identifier
    if params['Digits'] == '2'
      @language = "es-ES"
    elsif params['Digits'] == '1'
      @language = "en-US"
    end
    @language = params[:language] if @language.blank?
    @post_to = BASE_URL + "/patient_identifier_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_identifier?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    render :action => "patient_identifier.xml.builder", :layout => false
    return
  end
  
  def patient_identifier_status
    @language = params[:language]
    CallLog.find(params[:call_id]).update_attributes(:patient_identifier_recording_sid => params[:RecordingSid])
    @post_to = BASE_URL + "/patient_reason_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_identifier_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    render :action => "patient_reason.xml.builder", :layout => false
  end
  
  def patient_reason_status
    @recording_url = params[:RecordingUrl]
    @language = params[:language]
    CallLog.find(params[:call_id]).update_attributes(:reason_for_consultation_recording_sid => params[:RecordingSid])
    redirect_to :action => 'patient_ready_for_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
    return
  end
  
  def patient_ready_for_call
    @language = params[:language]
    @post_to = BASE_URL + "/patient_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
    @redirect_to = BASE_URL + "/patient_ready_for_call?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
    render :action => "patient_ready_for_call.xml.builder", :layout => false
  end
  
  def patient_responce
    @language = params[:language]
    if params['Digits'] == '9'
      redirect_to :action => 'patient_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token]
      return
    end
    
    if params['Digits'] == '5'
      @post_to = BASE_URL + "/charges_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
      render :action => "call_charges.xml.builder", :layout => false
      return
    end
    
    if params['Digits'] == '1'
      @post_to = BASE_URL + "/doctor_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
      @patient_info_url = BASE_URL + "/patient_information?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
      render :action => "doctor_call.xml.builder", :layout => false
      return
    end
 
    redirect_to :action => 'patient_ready_for_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
    return
  end
  
  def charges_responce
    @language = params[:language]
    if params['Digits'] == '1'
      redirect_to :action => 'patient_ready_for_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
      return
    end
    
    if params['Digits'] != '1'
      @post_to = BASE_URL + "/charges_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
      render :action => "call_charges.xml.builder", :layout => false
      return
    end
  end
  
  def patient_information
    @language = params[:language]
    call_log = CallLog.find(params[:call_id])
    @recording_url = "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{call_log.patient_identifier_recording_sid}"
    render :action => "patient_information.xml.builder", :layout => false
  end
  
  def doctor_responce
    @language = params[:language]
    CallLog.find(params[:call_id]).update_attributes(:conversation_recording_sid => params[:RecordingSid],:conversation_call_status =>params[:DialCallStatus])
    if ["busy", "no-answer", "failed", "canceled"].include? params[:DialCallStatus]
      render :action => "goodbye.xml.builder", :layout => false 
      return
    end
    render :nothing => true
  end
  
  # TwiML response saying with the goodbye message. Twilio will detect no
  # further commands after the Say and hangup 
  def goodbye
    render :action => "goodbye.xml.builder", :layout => false 
  end
  
  def call_status
    call_log = CallLog.find(params[:call_id])
    call_log.update_attributes(:call_sid => params[:CallSid], :call_duration =>params[:CallDuration])
    if params[:attempt] == "first" && params[:CallStatus] == "no-answer"
      sleep(2.minutes)
      Rails.logger.info "making second attempt"
      redirect_to :action => 'makecall', :call_id=> params[:call_id], :user_email=> params[:user_email], :user_token=>params[:user_token], :number => params["To"], :attempt => "second"
      return
    end
    if call_log.patient_identifier_recording_sid.nil? || call_log.reason_for_consultation_recording_sid.nil?
      data = {
        :from => TWILIO_CONFIG['from'],
        :to =>  current_user.mobile_number,
        :url => BASE_URL + "/registration_info?user_email=#{params[:user_email]}&user_token=#{params[:user_token]}",
      }
      begin
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        client.account.calls.create data
      rescue StandardError => msg
        render :status => 401,
          :json => { :success => false,
          :info => "Error #{msg}",
          :data => {} }
        return
      end
    end
    render :nothing => true
  end
  
  def registration_info
    render :action => "registration_info.xml.builder", :layout => false
  end
  
  
end
