class BillingSummariesController < ApplicationController
  
  def index
    @billing_summaries = []
    if current_user.has_role? :intended_recipient
      @billing_summaries = BillingSummary.group(:datetime_constant).select("sum(billable_ammount) as total_ammount, sum(call_logs.conversation_call_duration) as total_duration,billing_summaries.created_at").billing_summary_by_user(current_user.parent.id).paginate(:page => params[:page], :per_page => 10).order("billing_summaries.updated_at desc")
    end
  end
  
end