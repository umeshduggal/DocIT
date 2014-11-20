class ConsultationCharge < ActiveRecord::Base
   attr_accessible :charges, :user_id, :consultation_type_id
   belongs_to :user
   belongs_to :consultation_type
   validates :charges, presence: true
end
