class RenameIntendedRecipientEmailField < ActiveRecord::Migration
  def up
    rename_column :intended_recipients, :intended_recipient_email, :email
  end

  def down
    rename_column :intended_recipients, :email, :intended_recipient_email
  end
end
