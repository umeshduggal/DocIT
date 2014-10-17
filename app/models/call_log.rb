class CallLog < ActiveRecord::Base
  attr_accessible :call_duration, :call_sid, :conversation_call_status, :conversation_recording_sid, :patient_identifier_recording_sid, 
    :patient_mobile_number, :reason_for_consultation_recording_sid, :user_id, :conversation_call_duration, :call_status, :time_of_conversation
  belongs_to :user
  
  def patient_identifier_link
    return "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{self.patient_identifier_recording_sid}" unless self.patient_identifier_recording_sid.nil?
    '#'
  end
  
  def reason_for_consultation_link
    return "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{self.reason_for_consultation_recording_sid}" unless self.reason_for_consultation_recording_sid.nil?
    '#'
  end
  
  def conversation_recording_link
    return "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{self.conversation_recording_sid}" unless self.conversation_recording_sid.nil?
    '#'
  end
  
end
