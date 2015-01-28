class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :trackable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,  :validatable, :confirmable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :practice_name, :mobile_number, :verification_code, :verified, :parent_id,
    :intended_recipients_attributes, :assignments_attributes, :title_id, :mobile_number_confirmation,:consultation_charges_attributes,
    :terms_of_service,:email_confirmation, :platform

  before_save :ensure_authentication_token
  validates :first_name, :last_name, :platform, presence: true
  validates :mobile_number, presence: true, :if => :check_user_role
  validates :mobile_number, length: {minimum: 10}, :allow_blank => true
  validates :mobile_number, confirmation: true
  validates :email, confirmation: true
  validates :terms_of_service, :acceptance => {:accept => true}
  has_many :intended_recipients, :dependent => :destroy
  accepts_nested_attributes_for :intended_recipients, :allow_destroy => true
  
  has_many :subscriptions
  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  accepts_nested_attributes_for :assignments,
        :reject_if => lambda {|a| a[:role_id].blank? },
          :allow_destroy => :true
  has_many :call_logs, :dependent => :destroy
  has_many :consultation_charges, :dependent => :destroy
  accepts_nested_attributes_for :consultation_charges, :allow_destroy => true
  has_many :consultation_types, :through => :consultation_charges
  belongs_to :title
  #belongs_to :parent, :class_name => "User" 
 
  after_save :send_welcome_email, :if => proc { |l| l.confirmed_at_changed? && l.confirmed_at_was.nil? }
  
  def send_welcome_email
    if self.has_role? :doctor 
      UserMailer.welcome_email(self).deliver
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
  
  def name
    [self.title.to_s, self.first_name, self.last_name].compact.join(" ") rescue '' 
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
  
end
