class CallLogController < ApplicationController
  
  def index
    @call_logs = []
    if current_user.has_role? :doctor
      @call_logs = current_user.call_logs.where("archive=?",false).paginate(:page => params[:page], :per_page => 10).order("updated_at desc")
    elsif current_user.has_role? :intended_recipient
      user_ids = IntendedRecipient.select(:user_id).where(:email => current_user.email).map(&:user_id)
      @call_logs = CallLog.where(user_id: user_ids, archive: false).paginate(:page => params[:page], :per_page => 10).order("updated_at desc")
    end
  end
  
  def archive
    CallLog.find(params[:id]).update_attributes(:archive=> params[:archive])
    redirect_to call_logs_url
  end
  
  # GET /call_logs/1
  def show
    @call_log = CallLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @call_log }
    end
  end
  
  def send_call_log
    
  end
  
end