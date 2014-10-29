class AddDeletedAtToCallLogs < ActiveRecord::Migration
  def change
    add_column :call_logs, :deleted_at, :datetime
  end
end
