class BillingSummary < ActiveRecord::Base
  attr_accessible :billable_ammount, :call_log_id, :datetime_constant
  belongs_to :call_log
  
  scope :billing_summary_by_user, lambda{ |user_id| { :joins=>[:call_log], :conditions => [ 'call_logs.user_id = ?', "#{user_id}" ] } }
  
end
