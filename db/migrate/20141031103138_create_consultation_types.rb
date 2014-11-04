class CreateConsultationTypes < ActiveRecord::Migration
  def change
    create_table :consultation_types do |t|
      t.integer :lower_limit
      t.integer :upper_limit
      t.string :description
      t.timestamps
    end
  end
end
