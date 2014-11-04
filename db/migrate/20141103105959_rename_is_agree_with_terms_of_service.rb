class RenameIsAgreeWithTermsOfService < ActiveRecord::Migration
  def up
    rename_column :users, :is_agree, :terms_of_service
  end

  def down
    rename_column :users, :terms_of_service, :is_agree
  end
end
