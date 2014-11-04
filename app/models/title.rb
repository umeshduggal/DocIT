class Title < ActiveRecord::Base
   attr_accessible :name
   has_many :users
   def to_s
     self.name
   end
end
