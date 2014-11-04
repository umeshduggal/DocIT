class CreateConsultationCharges < ActiveRecord::Migration
  def change
    create_table :consultation_charges do |t|
      t.belongs_to :user
      t.belongs_to :consultation_type
      t.string :charges
      t.timestamps
    end
  end
end
