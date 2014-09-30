require 'paypal-sdk-merchant'
class Subscription < ActiveRecord::Base
  validates :token, uniqueness: true
  validates :amount, presence: true
  attr_accessible :amount, :token, :payer_id, :canceled, :auto_renew, :start_date, :expire_date, :credit_card_number, :completed, :email
  belongs_to :user
  
end
