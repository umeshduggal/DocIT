class CallLogController < ApplicationController
  
  def index
    @call_logs = []
    if current_user.has_role? :doctor
      @call_logs = current_user.call_logs.with_deleted.where("archive= ? and created_at > ? and patient_mobile_number LIKE ?",false, 10.years.ago, "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 10).order("created_at desc")
    elsif current_user.has_role? :intended_recipient
      user_ids = IntendedRecipient.select(:user_id).where(:email => current_user.email).map(&:user_id)
      @call_logs = CallLog.where("user_id IN (?) and archive= ? and patient_mobile_number LIKE ?", user_ids, false, "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 10).order("created_at desc")
    end
  end
  
  def archive
    CallLog.find(params[:id]).update_attributes(:archive=> params[:archive])
    redirect_to call_logs_url
  end
  
  def review
    CallLog.find(params[:id]).update_attributes(:reviewed => true)
    respond_to do |format|
      format.html # show.html.erb
      format.json { head :no_content  }
    end
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
  
  def send_call_log_mail
    if User.find_by_email(params[:email])
      UserMailer.send_call_log(params).deliver
      flash[:notice] = 'Mail Sent successfully.'
    else
      flash[:error] = 'Enter valid user email id.'
    end
    redirect_to :back
  end
  
end