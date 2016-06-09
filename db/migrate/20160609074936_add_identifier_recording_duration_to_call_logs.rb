class AddIdentifierRecordingDurationToCallLogs < ActiveRecord::Migration
  def change
    add_column :call_logs, :identifier_recording_duration, :string
  end
end
