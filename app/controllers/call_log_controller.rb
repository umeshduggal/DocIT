class CallLogController < ApplicationController
  
  def index
    @call_logs = current_user.call_logs
  end
  
end