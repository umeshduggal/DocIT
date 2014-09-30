class CreateAssignments < ActiveRecord::Migration
  def up
     create_table :assignments do |t|
      t.belongs_to :user
      t.belongs_to :role
      t.timestamps
    end
  end

  def down
    drop_table :assignments
  end
end
