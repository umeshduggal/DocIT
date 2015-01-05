class CallLog < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :call_duration, :call_sid, :conversation_call_status, :conversation_recording_sid, :patient_identifier_recording_sid, 
    :patient_mobile_number, :reason_for_consultation_recording_sid, :user_id, :conversation_call_duration, :call_status, :time_of_conversation, :archive, :reviewed
  belongs_to :user
  has_one :billing_summary, :dependent => :destroy
  scope :call_log_billing_summary, lambda{ |str| { :includes=>[:billing_summary], :conditions => [ 'billing_summaries.datetime_constant= ?', "#{str}" ] } }
  #CallLog.includes(:billing_summary).where("billing_summaries.datetime_constant= '1416480148'")
  
  
  def patient_identifier_link
    return "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{self.patient_identifier_recording_sid}" unless self.patient_identifier_recording_sid.nil?
    ''
  end
  
  def reason_for_consultation_link
    return "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{self.reason_for_consultation_recording_sid}" unless self.reason_for_consultation_recording_sid.nil?
    ''
  end
  
  def conversation_recording_link
    return "http://api.twilio.com/2010-04-01/Accounts/#{TWILIO_CONFIG['sid']}/Recordings/#{self.conversation_recording_sid}" unless self.conversation_recording_sid.nil?
    ''
  end
  
  def conversation_datetime
    self.time_of_conversation.strftime("%m/%d/%Y %H:%M:%S") rescue nil
  end
  
  def billing_summary_generated?
    self.billing_summary ?  true : false
  end
  
  def updated_at
    super.strftime("%Y-%m-%d %H:%M:%S") rescue super
  end
  
end
