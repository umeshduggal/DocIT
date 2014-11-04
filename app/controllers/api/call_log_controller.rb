# To change this template, choose Tools | Templates
# and open the template in the editor.

class Api::CallLogController < ApplicationController
  # base URL of this application
 skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
 respond_to :json
 
  def index
    begin
      call_log = current_user.call_logs
      call_log = call_log.as_json(:only => [ :id,:patient_mobile_number, :conversation_call_status,:conversation_call_duration, :time_of_conversation, :call_status,:conversation_call_status,:call_duration],
        :methods => [:patient_identifier_link,:reason_for_consultation_link,:conversation_recording_link])
      count = call_log.length
    rescue StandardError => msg
      render :status => 401,
        :json => { :success => false,
        :info => "Error #{msg}",
        :data => {} }
      return
    end
    render :status => 200,
      :json => { :success => true,
      :info => {:name => current_user.name, :practice_name => current_user.practice_name, :total => count },
      :data => call_log }
  end
  
  def destroy
    begin
    @call_log = CallLog.find(params[:id])
    @call_log.destroy
    rescue StandardError => msg
      render :status => 401,
        :json => { :success => false,
        :info => "Error #{msg}",
        :data => {} }
      return
    end
    render :status => 200,
      :json => { :success => true,
      :info => "Record deleted sucessfully.",
      :data => {} }
  end
  
  
  
end
