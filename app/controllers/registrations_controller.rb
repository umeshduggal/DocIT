class RegistrationsController < Devise::RegistrationsController
  def new
    #@credit_card_detail = CreditCardDetail.new
    build_resource({})
    @validatable = devise_mapping.validatable?
    if @validatable
      @minimum_password_length = resource_class.password_length.min
    end
    resource.intended_recipients.build
    5.times { resource.consultation_charges.build }
    resource.assignments.build
    respond_with self.resource
  end

  def create
    #@credit_card_detail = CreditCardDetail.new(params[:credit_card_detail])
    build_resource(sign_up_params)   
    custom_errors = nil
    
    if resource.valid? # && @credit_card_detail.valid?
      if params[:user][:mobile_number].length == 10
        params[:user][:mobile_number] = "+1".concat(params[:user][:mobile_number])
        params[:user][:mobile_number_confirmation] = "+1".concat(params[:user][:mobile_number_confirmation])
      elsif params[:user][:mobile_number].length > 10
        if params[:user][:mobile_number].start_with?("001")
          params[:user][:mobile_number] = "+1".concat(params[:user][:mobile_number][-10,10])
          params[:user][:mobile_number_confirmation] = "+1".concat(params[:user][:mobile_number_confirmation][-10,10])
        end
      end
      @subscription =  Subscription.where(:email => params[:user][:email], :completed => true).first
      if @subscription.blank?
        #@client_profile, @subscription  = @credit_card_detail.create_payment_profile params
      end
      if  true
        super
        unless resource.id.nil?
#          @subscription.user_id = resource.id
#          @subscription.save!   
          begin
            # Instantiate a Twilio client
            client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
            # Create and send an SMS message
            verification_number = rand.to_s[2...8]
            resource.update_attributes(:verification_code => verification_number) 
            response = client.account.sms.messages.create(
              from: TWILIO_CONFIG['from'],
              to: resource.mobile_number,
              body: "Thanks for signing up on DocIt. To verify your account mobile number, please enter code #{verification_number}."
            )
            
          rescue StandardError => msg
            Rails.logger.info "---- Twilio error -----"
            Rails.logger.info msg.inspect
            Rails.logger.info "---- Twilio error -----"
          end    
        else
          custom_errors = []
        end
      else
        custom_errors = @client_profile.collect { |e| e.LongMessage }
      end
    else
#      @credit_card_detail.valid?
#      unless @credit_card_detail.errors.full_messages.blank?
#        custom_errors = @credit_card_detail.errors.full_messages
#      else
#        custom_errors = []
#      end
       custom_errors = []
    end
    
    unless custom_errors.nil?
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      flash.now[:error] =  "<li>#{custom_errors.join("</li><li>")}</li>" unless custom_errors.blank?
      render action: "new"
    end
    
  end
  
   # GET /resource/edit
  def edit
    if resource.consultation_charges.blank?
      5.times { resource.consultation_charges.build }
    end
    render :edit
  end

  def update
    super
  end
  

  
  protected
  
  def after_inactive_sign_up_path_for(resource)
    verification_path(resource.authentication_token)
  end
  
#  def after_sign_up_path_for(resource)
#    verification_path(resource.authentication_token)
#  end
  
end
