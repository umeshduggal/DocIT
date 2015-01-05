class AddReviewedToCallLog < ActiveRecord::Migration
  def change
    add_column :call_logs, :reviewed, :boolean, default: false
  end
end
