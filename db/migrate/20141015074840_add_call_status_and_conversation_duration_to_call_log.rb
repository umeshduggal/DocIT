class AddCallStatusAndConversationDurationToCallLog < ActiveRecord::Migration
  def change
    add_column :call_logs, :conversation_call_duration, :string
    add_column :call_logs, :call_status, :string
  end
end
