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
    send_file 'public/DocIt.apk', :type => 'application/vnd.android.package-archive', :disposition => "attachment"
  end
  
  def number_verification
    @user = User.where(id: params[:user_id]).first
    verified = @user.verification params[:verification_code]
    if verified
      UserMailer.welcome_email(@user).deliver
      begin
        # Instantiate a Twilio client
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        # Create and send an SMS message
        link = ""
        if @user.platform == "android"
          link = "http://tinyurl.com/hepl9ol"
        elsif @user.platform == "ios"
          link = "http://tinyurl.com/n54nbem"
        end
        Rails.logger.info link.inspect
        response = client.account.sms.messages.create(
          from: TWILIO_CONFIG['from'],
          to: @user.mobile_number,
          body: "https://docitamerica.com/  Please download the app from following link: #{link}"
        )

      rescue StandardError => msg
        Rails.logger.info "---- Twilio send sms error -----"
        Rails.logger.info msg.inspect
        Rails.logger.info "---- Twilio send sms error -----"
      end
      flash[:notice] = 'You are now registered with Docit. If you are on your smartphone, Please Download the App by pressing the link below. You must be on your smartphone to download the App. If you are not on your smartphone, please go to your smartphone, and open www.docitamerica.com and Sign In. Once you Sign In, you will see the link to Download the Application.'
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
      # Create and send an SMS message
      verification_number = rand.to_s[2...8]
      Rails.logger.info "verification_number #{verification_number}"
      User.update_all({:verification_code => verification_number},
                   ['mobile_number = ?', "#{params[:mobile_number]}"])
      #@user.update_attributes(:verification_code => verification_number) 
      begin
        # Instantiate a Twilio client
        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
        
        
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
