class CallLog < ActiveRecord::Base
  attr_accessible :call_duration, :call_sid, :conversation_call_status, :conversation_recording_sid, :patient_identifier_recording_sid, :patient_mobile_number, :reason_for_consultation_recording_sid, :user_id
  belongs_to :user
end
