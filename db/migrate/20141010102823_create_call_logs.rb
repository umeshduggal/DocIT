class CreateCallLogs < ActiveRecord::Migration
  def change
    create_table :call_logs do |t|
      t.integer :user_id
      t.string :call_sid
      t.string :patient_mobile_number
      t.string :call_duration
      t.string :patient_identifier_recording_sid
      t.string :reason_for_consultation_recording_sid
      t.string :conversation_recording_sid
      t.string :conversation_call_status

      t.timestamps
    end
  end
end
