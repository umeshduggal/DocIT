class BillingSummariesController < ApplicationController
  
  def index
    @billing_summaries = {}
    if current_user.has_role? :intended_recipient
      @user_ids = IntendedRecipient.select(:user_id).where(:email => current_user.email).map(&:user_id)
      @user_ids.each {|user_id| 
        @billing_summaries[user_id] =  BillingSummary.group(:datetime_constant).
          select("call_log_id, sum(billable_ammount) as total_ammount, sum(call_logs.conversation_call_duration) as total_duration, billing_summaries.created_at").
          billing_summary_by_user(user_id).paginate(:page => params[:page], :per_page => 10).order("billing_summaries.updated_at desc")
        
      }
    end
  end
  
end