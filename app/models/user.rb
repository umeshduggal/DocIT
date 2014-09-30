class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :trackable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,  :validatable,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :practice_name, :mobile_number, :verification_code, :verified, :parent_id, :intended_recipients_attributes, :assignments_attributes

  before_save :ensure_authentication_token
  validates :mobile_number, presence: true
  validates :mobile_number, uniqueness: true
  has_many :intended_recipients, :dependent => :destroy
  accepts_nested_attributes_for :intended_recipients, :allow_destroy => true
  
  
  has_many :subscriptions
  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  accepts_nested_attributes_for :assignments,
        :reject_if => lambda {|a| a[:role_id].blank? },
          :allow_destroy => :true
        
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
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
  
end
