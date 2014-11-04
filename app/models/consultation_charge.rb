class ConsultationCharge < ActiveRecord::Base
   attr_accessible :charges, :user_id, :consultation_type_id
   belongs_to :user
   belongs_to :consulation_type
end
