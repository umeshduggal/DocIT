class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :trackable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,  :validatable,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :practice_name, :mobile_number, :verification_code, :verified, :parent_id, :intended_recipients_attributes, :assignments_attributes

  before_save :ensure_authentication_token
  validates :mobile_number, presence: true, :if => :check_user_role
  validates :mobile_number, uniqueness: true, allow_nil: true
  has_many :intended_recipients, :dependent => :destroy
  accepts_nested_attributes_for :intended_recipients, :allow_destroy => true
  
  has_many :subscriptions
  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  accepts_nested_attributes_for :assignments,
        :reject_if => lambda {|a| a[:role_id].blank? },
          :allow_destroy => :true
  has_many :call_logs, :dependent => :destroy
  after_create :send_invitation_email

  def send_invitation_email
    self.assignments.each do |a|
        if a.has_role? :doctor
          self.intended_recipients.each do |ir| 
            u = UserMailer.send_registration_link(self, ir).deliver
            Rails.logger.info u.inspect
          end
      end
    end
  end
  
  def check_user_role
    self.assignments.each do |a|
      return a.has_role? :doctor
    end
  end
  
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
  
  def verification code
    if self.verification_code == code
      self.verified = true
      self.save!
      self
    else
      false
    end
  end
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  def verified?
    return self.verified unless self.mobile_number.blank?
    true
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
  
end
