# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150120131323) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "billing_summaries", :force => true do |t|
    t.integer  "call_log_id"
    t.string   "billable_ammount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "datetime_constant"
  end

  create_table "call_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "call_sid"
    t.string   "patient_mobile_number"
    t.string   "call_duration"
    t.string   "patient_identifier_recording_sid"
    t.string   "reason_for_consultation_recording_sid"
    t.string   "conversation_recording_sid"
    t.string   "conversation_call_status"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "conversation_call_duration"
    t.string   "call_status"
    t.datetime "time_of_conversation"
    t.datetime "deleted_at"
    t.boolean  "archive",                               :default => false
    t.boolean  "reviewed",                              :default => false
  end

  create_table "consultation_charges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "consultation_type_id"
    t.string   "charges"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "consultation_types", :force => true do |t|
    t.integer  "lower_limit"
    t.integer  "upper_limit"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "intended_recipients", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "amount",     :default => 20
    t.string   "token"
    t.string   "identifier"
    t.string   "payer_id"
    t.boolean  "recurring",  :default => false
    t.boolean  "digital",    :default => false
    t.boolean  "popup",      :default => false
    t.boolean  "completed",  :default => false
    t.boolean  "canceled",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "amount",             :default => 20
    t.integer  "user_id"
    t.string   "credit_card_number"
    t.string   "token"
    t.string   "payer_id"
    t.boolean  "auto_renew",         :default => true
    t.boolean  "completed",          :default => false
    t.boolean  "canceled",           :default => false
    t.datetime "start_date"
    t.datetime "expire_date"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "email"
  end

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",             :default => "",    :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "practice_name"
    t.string   "mobile_number"
    t.string   "device_uid"
    t.string   "type"
    t.integer  "parent_id"
    t.string   "verification_code"
    t.boolean  "verified",               :default => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "last_name"
    t.integer  "title_id"
    t.string   "confirm_mobile_number"
    t.boolean  "terms_of_service"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "platform"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
