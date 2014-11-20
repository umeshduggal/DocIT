class CreateBillingSummaries < ActiveRecord::Migration
  def change
    create_table :billing_summaries do |t|
      t.belongs_to :call_log
      t.string :billable_ammount
      t.timestamps
    end
  end
end
