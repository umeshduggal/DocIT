class IntendedRecipient < ActiveRecord::Base
 attr_accessible :email, :email_confirmation,:user_id
 validates :email, presence: true
 validates :email, confirmation: true
 validates :email, :uniqueness => true
 
 belongs_to :user
 validate :validate_email_registered

  def validate_email_registered
    if User.find_by_email(self.email) && IntendedRecipient.find_by_email(self.email).blank?
      errors[:base] << "Email has already been registered" 
    end
  end
 
 after_create :send_invitation_email

  def send_invitation_email
    u = UserMailer.send_registration_link(self.user, self).deliver
    Rails.logger.info u.inspect
  end
  
 def registered?
   return @u if @u = User.find_by_email(self.email)
   false
 end 
 
 def enabled?
   if registered?
     !@u.access_locked?
   else
     false
   end
 end
 
 def registration_date
   if registered?
     @u.created_at.strftime("%Y-%m-%d %H:%M:%S") rescue nil
   else
     "N/A"
   end
 end
 
 def name
   if registered?
     [@u.first_name, @u.last_name].compact.join(" ") rescue '' 
   else
     "-"
   end
 end
  
end
