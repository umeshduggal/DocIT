class IntendedRecipient < ActiveRecord::Base
 attr_accessible :email, :email_confirmation
 validates :email, presence: true
 validates :email, confirmation: true
 belongs_to :user
  
end
