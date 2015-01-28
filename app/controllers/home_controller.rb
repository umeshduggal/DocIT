# To change this template, choose Tools | Templates
# and open the template in the editor.

class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :eula, :contact_us, :about_us, :send_mail, :info_for_billers_coders, :download_pdf, :download_android_app, :mobile_number_verification, :verification_new, :resend_verification, :number_verification]
  
  def index
  end
  
  def contact_us
  end
  
  def about_us
  end
  
  def mobile_number_verification
    user = User.where(authentication_token: params[:user_token]).first
    @user_id = user.id
  end

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
      redirect_to :back
      return
    end
    redirect_to root_url
  end
  
  def verification_new
    render "home/mobile/new" 
  end
  
  def resend_verification
    @user = User.where(mobile_number: params[:mobile_number]).first
    if @user.blank?
      flash[:error] = 'Mobile Number not found.'
      redirect_to :back
      return
    else
      begin
        # Instantiate a Twilio client
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        # Create and send an SMS message
        verification_number = rand.to_s[2...8]
        @user.update_attributes(:verification_code => verification_number) 
        response = client.account.sms.messages.create(
          from: TWILIO_CONFIG['from'],
          to: @user.mobile_number,
          body: "To verify your account mobile number, please enter code #{verification_number}."
        )

      rescue StandardError => msg
        Rails.logger.info "---- Twilio error -----"
        Rails.logger.info msg.inspect
        Rails.logger.info "---- Twilio error -----"
      end
      flash[:notice] = 'Verification code has been sent.'
    end
    redirect_to verification_url(@user.authentication_token)
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
