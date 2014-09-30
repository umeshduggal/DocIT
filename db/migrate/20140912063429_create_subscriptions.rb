class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :amount, default: 20
      t.references :user, :index => true
      t.string :credit_card_number, :token, :payer_id
      t.boolean :auto_renew, default: true
      t.boolean :completed, :canceled, default: false
      t.datetime :start_date, :expire_date
      t.timestamps
    end
  end
end
