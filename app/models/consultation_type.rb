class ConsultationType < ActiveRecord::Base
   attr_accessible :lower_limit, :upper_limit, :description
   has_many :consultation_charges
   has_many :users, :through => :consultation_charges
end
