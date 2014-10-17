class AddTimeOfConversationToCallLog < ActiveRecord::Migration
  def change
    add_column :call_logs, :time_of_conversation, :datetime
  end
end
