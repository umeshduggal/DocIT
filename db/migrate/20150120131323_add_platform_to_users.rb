class AddPlatformToUsers < ActiveRecord::Migration
  def change
    add_column :users, :platform, :string
  end
end
