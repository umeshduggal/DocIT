# To change this template, choose Tools | Templates
# and open the template in the editor.

class IntendedRecipientsController < ApplicationController
  
  def index
    if current_user.has_role? :doctor
      @managers = current_user.intended_recipients
    end
  end
  
  def user_action
    email = IntendedRecipient.find(params[:id]).email
    user = User.find_by_email(email)
    if params[:enable] == 'false'
      @res = user.lock_access!(opts = {send_instructions: false })
    elsif params[:enable] == 'true'
      @res = user.unlock_access!
    end
    
    redirect_to billing_manager_url
  end
  
  
  def new
    @intended_recipient = IntendedRecipient.new
    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.json { render json: @intended_recipient }
    end
  end
  
  def create
    @intended_recipient = IntendedRecipient.new(params[:intended_recipient])
    respond_to do |format|
      if @intended_recipient.save
        format.html { redirect_to billing_manager_url, notice: 'IntendedRecipient was successfully created.' }
        format.json { render json: @intended_recipient, status: :created, location: @intended_recipient }
      else
        format.html { render action: 'new' }
        format.json { render json: @intended_recipient.errors, status: :unprocessable_entity }
      end
    end
  end
  

end
