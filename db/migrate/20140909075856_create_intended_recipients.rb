class CreateIntendedRecipients < ActiveRecord::Migration
  def up
    create_table :intended_recipients do |t|
                    t.string :intended_recipient_email
                    t.references :user, :index => true
                    
                    t.timestamps
               end
  end

  def down
    drop_table :intended_recipients
  end
  
end
