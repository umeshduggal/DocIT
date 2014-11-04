class AddAndRenameUserProfileColumnsToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
    add_column :users, :title_id, :integer
    add_column :users, :is_agree, :boolean
  end
end
