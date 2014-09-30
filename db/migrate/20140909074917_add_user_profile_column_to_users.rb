class AddUserProfileColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :practice_name, :string
    add_column :users, :mobile_number, :string
    add_column :users, :device_uid, :string
    add_column :users, :type, :string
    add_column :users, :parent_id, :integer
  end
end
