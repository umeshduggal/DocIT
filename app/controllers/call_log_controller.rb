class CallLogController < ApplicationController
  
  def index
    @call_logs = []
    if current_user.has_role? :doctor
      @call_logs = current_user.call_logs.paginate(:page => params[:page], :per_page => 10).order("updated_at desc")
    elsif current_user.has_role? :intended_recipient
      @call_logs = current_user.parent.call_logs.paginate(:page => params[:page], :per_page => 10).order("updated_at desc")
    end
  end
  
end