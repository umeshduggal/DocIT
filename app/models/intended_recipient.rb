class IntendedRecipient < ActiveRecord::Base
 attr_accessible :email
 validates :email, presence: true
 belongs_to :user
  
end
