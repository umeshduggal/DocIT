# To change this template, choose Tools | Templates
# and open the template in the editor.

class Api::TwilioController < ApplicationController
  
  
  # base URL of this application
  BASE_URL = "http://www.docitamerica.com/api/twilio"
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
      :IfMachine => 'Continue',
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
    if params[:AnsweredBy] == "human"
      @post_to = BASE_URL + "/language_selection?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}"
      @redirect_to = BASE_URL + "/patient_call?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}"
      render :action => "patient_call.xml.builder", :layout => false
    else
      render :action => "voicemail_message.xml.builder", :layout => false
    end
    
  end
  
  def language_selection
    if params['Digits'] == '2'
      redirect_to :action => 'patient_identifier', :call_id => params[:call_id], :user_email=> params[:user_email],:user_token=> params[:user_token], :Digits=> "2" 
      return
    end
    if params['Digits'] == '1'
      @post_to = BASE_URL + "/patient_identifier?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}"
      @redirect_to = BASE_URL + "/language_selection?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&Digits=1"
      render :action => "language_selection.xml.builder", :layout => false
      return
    end
    redirect_to :action => 'patient_call', :call_id => params[:call_id], :user_email=> params[:user_email],:user_token=> params[:user_token]
    return
  end
  
  def patient_identifier
    if params[:repeat]
      repeat = params[:repeat].to_i + 1
    else
      repeat = 1
    end
    if params['Digits'] == '2'
      @language = "es-ES"
    elsif params['Digits'] == '1'
      @language = "en-US"
    end
    @language = params[:language] if @language.blank?
    @post_to = BASE_URL + "/patient_identifier_record?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_identifier?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}&repeat=#{repeat}"
    if repeat <= 5
      if @language == "es-ES"
        render :action => "patient_identifier_spn.xml.builder", :layout => false
      else
        render :action => "patient_identifier.xml.builder", :layout => false
      end
    else
      render :action => "hangup.xml.builder", :layout => false
    end
  end
  
  def patient_identifier_record
    @language = params[:language] 
    @post_to = BASE_URL + "/patient_identifier_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_identifier?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    if params['Digits'] == '1'
      render :action => "patient_identifier_record.xml.builder", :layout => false
      return
    end
    if @language == "es-ES"
      render :action => "patient_identifier_spn.xml.builder", :layout => false
    else
      render :action => "patient_identifier.xml.builder", :layout => false
    end
    return
  end
  
  def patient_identifier_status
    @language = params[:language]
    @post_to = BASE_URL + "/patient_identifier_record?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_identifier?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}&repeat=#{2}"
    if params['Digits'] == '2'
      CallLog.find(params[:call_id]).update_attributes(:patient_identifier_recording_sid => params[:RecordingSid])
      redirect_to :action => 'patient_reason', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
    else
      if @language == "es-ES"
        render :action => "patient_identifier_spn.xml.builder", :layout => false
      else
        render :action => "patient_identifier.xml.builder", :layout => false
      end
    end
  end
  
  def patient_reason
    if params[:repeat]
      repeat = params[:repeat].to_i + 1
    else
      repeat = 1
    end
    @language = params[:language]
    @post_to = BASE_URL + "/patient_reason_record?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_reason?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}&repeat=#{repeat}"
    if repeat <= 5
      if @language == "es-ES"
        render :action => "patient_reason_spn.xml.builder", :layout => false
      else
        render :action => "patient_reason.xml.builder", :layout => false
      end
    else
      render :action => "hangup.xml.builder", :layout => false
    end    
  end
  
  def patient_reason_record
    @language = params[:language] 
    @post_to = BASE_URL + "/patient_reason_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_reason?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    if params['Digits'] == '1'
      render :action => "patient_reason_record.xml.builder", :layout => false
      return
    end
    if @language == "es-ES"
      render :action => "patient_reason_spn.xml.builder", :layout => false
    else
      render :action => "patient_reason.xml.builder", :layout => false
    end
    return
  end
  
  def patient_reason_status
    @recording_url = params[:RecordingUrl]
    @language = params[:language]
    @post_to = BASE_URL + "/patient_reason_record?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}"
    @redirect_to = BASE_URL + "/patient_reason?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{@language}&repeat=#{2}"
    if params['Digits'] == '2'
      CallLog.find(params[:call_id]).update_attributes(:reason_for_consultation_recording_sid => params[:RecordingSid])
      redirect_to :action => 'patient_ready_for_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
      return
    else
      if @language == "es-ES"
        render :action => "patient_reason_spn.xml.builder", :layout => false
      else
        render :action => "patient_reason.xml.builder", :layout => false
      end
    end
  end
  
  def patient_ready_for_call
    if params[:repeat]
      repeat = params[:repeat].to_i + 1
    else
      repeat = 1
    end
    @language = params[:language]
    @post_to = BASE_URL + "/patient_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
    @redirect_to = BASE_URL + "/patient_ready_for_call?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}&repeat=#{repeat}"
    if repeat <= 5
      if @language == "es-ES"
        render :action => "patient_ready_for_call_spn.xml.builder", :layout => false
      else
        render :action => "patient_ready_for_call.xml.builder", :layout => false
      end
    else
      render :action => "hangup.xml.builder", :layout => false
    end
  end
  
  def patient_responce
    @language = params[:language]
    if params['Digits'] == '9'
      redirect_to :action => 'patient_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token]
      return
    end
    
    if params['Digits'] == '5'
      @charges = []
      current_user.consultation_charges.each do |c| 
        @charges[c.consultation_type_id] = c.charges
      end
      @charges = [0,1,2,3,4,5] if @charges.length == 0
      @post_to = BASE_URL + "/charges_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
      if @language == "es-ES"
        render :action => "call_charges_spn.xml.builder", :layout => false
      else
        render :action => "call_charges.xml.builder", :layout => false
      end
      return
    end
    
    if params['Digits'] == '1'
      @patient_info_url = BASE_URL + "/patient_information?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
      @doctor_call_status = BASE_URL + "/doctor_call_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}&patient_number=#{params['Called']}"
      data = {
        :from => TWILIO_CONFIG['from'],
        :to => current_user.mobile_number,
        :url => @patient_info_url,
        :IfMachine => 'Hangup',
        :StatusCallback => @doctor_call_status
      }
      begin
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        client.account.calls.create data
      rescue StandardError => msg
        Rails.logger.info "Error--- #{msg.inspect}"
      end
      render :action => "doctor_call.xml.builder", :layout => false
      return
    end
 
    redirect_to :action => 'patient_ready_for_call', :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
    return
  end
  
  def charges_responce
    @language = params[:language]
    if params['Digits'] == '1'
      redirect_to :action => 'patient_responce', :Digits => params['Digits'], :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
      return
    end
    
    if params['Digits'] != '1'
      redirect_to :action => 'patient_responce', :Digits => 5, :call_id=> params[:call_id], :user_email=> params[:user_email],:user_token=>params[:user_token], :language => params[:language]
      return
    end
  end
  
  def patient_information
    @language = params[:language]
    call_log = CallLog.find(params[:call_id])
    call_log.update_attributes(:time_of_conversation=>Time.now)
    @recording_url = call_log.patient_identifier_link
    @post_to = BASE_URL + "/doctor_responce?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&language=#{params[:language]}"
    render :action => "patient_information.xml.builder", :layout => false
  end
  
  def doctor_responce
    @language = params[:language] 
    CallLog.find(params[:call_id]).update_attributes(:conversation_recording_sid => params[:RecordingSid],:conversation_call_status =>params[:DialCallStatus],:conversation_call_duration=>params[:RecordingDuration])
    
    if ["busy", "no-answer", "failed", "canceled"].include? params[:DialCallStatus]
      render :action => "goodbye.xml.builder", :layout => false 
      return
    end
    render :action => "patient_goodbye.xml.builder", :layout => false 
  end
  
  def doctor_call_status
    @language = params[:language]
    if ["busy", "no-answer", "failed", "canceled"].include? params[:CallStatus]
      CallLog.find(params[:call_id]).update_attributes(:conversation_call_status =>params[:CallStatus])
      client = Twilio::REST::Client.new TWILIO_CONFIG['sid'], TWILIO_CONFIG['token']
      # Loop over conferences and print out a property for each one
      client.account.conferences.list({
          :status => "in-progress",
          :friendly_name => current_user.mobile_number}).each do |conference|
        conference.participants.list.each do |participant|
          Rails.logger.info participant.inspect
          participant.delete
        end
      end
      unless params[:patient_number].start_with?("+")
        params[:patient_number] = "+"+params[:patient_number]
      end

      response = client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: params[:patient_number],
        body: "We are sorry but #{current_user.name} is no longer able to pick up the phone, we will leave a message. Goodbye."
      ) 
      response = client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: current_user.mobile_number,
        body: "You have missed a call back from #{params[:patient_number]} - Thank You Docit"
      )
      #render :action => "goodbye.xml.builder", :layout => false 
    end
    render :nothing => true 
    return
  end
  
  # TwiML response saying with the goodbye message. Twilio will detect no
  # further commands after the Say and hangup 
  def goodbye
    render :action => "goodbye.xml.builder", :layout => false 
  end
  
  def call_status
    call_log = CallLog.find(params[:call_id])
    #Rails.logger.info params.inspect
    call_log.update_attributes(:call_sid => params[:CallSid], :call_duration =>params[:CallDuration],:call_status => params[:CallStatus])
    if params[:attempt] == "first" && (params[:CallStatus] == "no-answer" || call_log.patient_identifier_recording_sid.nil? || call_log.reason_for_consultation_recording_sid.nil?)
      Rails.logger.info "making second attempt"
      sleep(120)
      Rails.logger.info "making second attempt"
      attempt = "second"
      data = {
        :from => TWILIO_CONFIG['from'],
        :to => params["To"],
        :url => BASE_URL + "/patient_call?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}",
        :IfMachine => 'Continue',
        :StatusCallback => BASE_URL + "/call_status?call_id=#{params[:call_id]}&user_email=#{params[:user_email]}&user_token=#{params[:user_token]}&attempt=#{attempt}"
      }
      begin
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        client.account.calls.create data
      rescue StandardError => msg
        render :nothing => true 
        return
      end
      render :nothing => true 
      return
    end
    if call_log.patient_identifier_recording_sid.nil? || call_log.reason_for_consultation_recording_sid.nil?
      begin
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        response = client.account.sms.messages.create(
          from: TWILIO_CONFIG['from'],
          to: current_user.mobile_number,
          body: "We are sorry but your party with number #{params['To']} is unavailable. A record will be made of your attempted call."
        )
      rescue StandardError => msg
        Rails.logger.info "Error #{msg}"
        render :nothing => true
        return
      end
    end
    render :nothing => true
  end
    
end
