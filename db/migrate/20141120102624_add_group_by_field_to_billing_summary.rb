class AddGroupByFieldToBillingSummary < ActiveRecord::Migration
  def change
    add_column :billing_summaries, :datetime_constant, :string
  end
end
