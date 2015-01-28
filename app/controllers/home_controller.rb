# To change this template, choose Tools | Templates
# and open the template in the editor.

class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :eula, :contact_us, :about_us, :send_mail, :info_for_billers_coders, :download_pdf, :download_android_app]
  
  def index
  end
  
  def contact_us
  end
  
  def about_us
  end
  
#  def videos
#  end

  def info_for_billers_coders
  end
  
  def download_pdf
    send_file 'public/ABN.3.11.pdf'
  end
  
  def download_android_app
    send_file 'public/DocIt.apk'
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


  def eula
    render :layout => false
  end
  
  def send_mail
    to = Rails.application.config.super_admin_mail_id
    UserMailer.send_feedback(to,params).deliver
    flash[:notice] = 'Form submitted successfully.'
    redirect_to :back
  end
  
end
