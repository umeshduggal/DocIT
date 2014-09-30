class GuestRegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    @validatable = devise_mapping.validatable?
    if @validatable
    @minimum_password_length = resource_class.password_length.min
    end
    resource.assignments.build
    @IntendedRecipient = IntendedRecipient.find(params[:id]) rescue nil
    respond_with self.resource
  end

  def create
    super
  end

  def update
    super
  end
  
  protected

  def after_sign_up_path_for(resource)
    root_url
  end
  
end
