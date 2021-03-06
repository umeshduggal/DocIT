class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
  
  def after_sign_in_path_for(resource)
    if current_user.has_role? :intended_recipient
      call_logs_path
    else
      super
    end
  end
  private
  
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)
 
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end
end
