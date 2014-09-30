# To change this template, choose Tools | Templates
# and open the template in the editor.

class Api::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create]
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  include Devise::Controllers::Helpers
  respond_to :json
  
  def create
    resource = User.find_for_database_authentication(:mobile_number => "+"+params[:user][:mobile_number]) unless params[:user].nil?
    return failure unless resource

    #warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    if sign_in resource, store: false
      return failure true unless resource.verified
      render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :data => { :auth_token => current_user.authentication_token,:user_email => current_user.email } }
    else
      return failure
    end
  end
  
  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end
  
  def failure verification_flag=false
    if verification_flag
      msg = "Login Failed. Mobile number is not verified"
    else
      msg = "Login Failed"
    end
    render :status => 401,
           :json => { :success => false,
                      :info => msg,
                      :data => {} }
  end
  
end
