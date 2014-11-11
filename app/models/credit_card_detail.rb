# To change this template, choose Tools | Templates
# and open the template in the editor.

class CreditCardDetail  < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  attr_accessible :credit_card_type,:credit_card_number,:exp_month,:exp_year, :CVV
  column :credit_card_type, :string
  column :credit_card_number, :string
  column :exp_month, :integer
  column :exp_year, :integer
  column :CVV, :integer
  validates :credit_card_type, presence: true
  validates :credit_card_number, presence: true
  validates :exp_month, presence: true
  validates :exp_year, presence: true
  #validates :CVV, presence: true
  validates :credit_card_number, numericality: { only_integer: true }
  validate :validate_cvv

    def validate_cvv
      if self.CVV.blank? || self.CVV.nil?
        errors[:base] << "CVV can't be blank"
      end
    end
  
  
  def create_payment_profile options
    @api = PayPal::SDK::Merchant::API.new
    # Build request object
       
    @create_recurring_payments_profile = @api.build_create_recurring_payments_profile({
        :CreateRecurringPaymentsProfileRequestDetails => {
          :CreditCard => {
            :CreditCardType => options[:credit_card_detail][:credit_card_type],
            :CreditCardNumber => options[:credit_card_detail][:credit_card_number],
            :ExpMonth => options[:credit_card_detail][:exp_month],
            :ExpYear => options[:credit_card_detail][:exp_year] },
          :RecurringPaymentsProfileDetails => {
            :SubscriberName => options[:user][:name],
            :BillingStartDate => Time.now },
#          :PayerInfo => {
#            :Payer => options[:user][:email]
#          },
          :ScheduleDetails => {
            :Description => "Welcome to the DocIT",
            :PaymentPeriod => {
              :BillingPeriod => "Month",
              :BillingFrequency => 1,
              :Amount => {
                :currencyID => "USD",
                :value => "1" } },
            :ActivationDetails => {
              :InitialAmount => {
                :currencyID => "USD",
                :value => "1" },
              :FailedInitialAmountAction => "CancelOnFailure" },
            :MaxFailedPayments => 1,
            :ActivationDetails => {
              :FailedInitialAmountAction => "ContinueOnFailure" },
            :AutoBillOutstandingAmount => "NoAutoBill" } } })

    # Make API call & get response
    @create_recurring_payments_profile_response = @api.create_recurring_payments_profile(@create_recurring_payments_profile)
    
    # Access Response
    if @create_recurring_payments_profile_response.success?
      @subscription = Subscription.create!(:payer_id => @create_recurring_payments_profile_response.CreateRecurringPaymentsProfileResponseDetails.ProfileID,
        :credit_card_number => options[:credit_card_detail][:credit_card_number].last(4),:token => @create_recurring_payments_profile_response.CorrelationID,
        :completed => true, :email => options[:user][:email], :start_date=> Time.now, :expire_date => Time.now + 1.month)
      [@create_recurring_payments_profile_response.CreateRecurringPaymentsProfileResponseDetails, @subscription]
    else
      Rails.logger.info "create_recurring_payments_profile_response.Errors"
      Rails.logger.info @create_recurring_payments_profile_response.Errors.inspect
      Rails.logger.info "create_recurring_payments_profile_response.Errors"
      @subscription = Subscription.create!(:credit_card_number => options[:credit_card_detail][:credit_card_number].last(4),:token => @create_recurring_payments_profile_response.CorrelationID,
        :canceled => true, :email => options[:user][:email])
      [@create_recurring_payments_profile_response.Errors, @subscription]
    end
  end
  
end
