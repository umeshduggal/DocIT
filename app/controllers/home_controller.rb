# To change this template, choose Tools | Templates
# and open the template in the editor.

class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :eula]
  
  def index
    
  end
  
  def number_verification
    @user = User.where(id: params[:user_id]).first
    verified = @user.verification params[:verification_code]
    if verified
      flash[:notice] = 'Mobile Number verified sucessfully.'
    else
      flash[:error] = 'Verification code is not valid.'
    end
    redirect_to root_url
  end
  
  def manage_billing_manager
    if current_user.has_role? :doctor
      @managers = current_user.intended_recipients
      
    end
    
  end

  def eula
    render :layout => false
  end
  
  def hello_email
    to = IntendedRecipient.last
    UserMailer.send_registration_link(User.last,to).deliver
    render :nothing => true
  end
  
end
