class Assignment < ActiveRecord::Base
  attr_accessible :user_id, :role_id
  belongs_to :user
  belongs_to :role
  
  def has_role?(role_sym)
    role.name.underscore.to_sym == role_sym 
  end
end