class AddArchiveToCallLogs < ActiveRecord::Migration
  def change
    add_column :call_logs, :archive, :boolean, default: false
  end
end
