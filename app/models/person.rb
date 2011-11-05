class Person < ActiveRecord::Base

  set_primary_key :full_name

  col :full_name

  #has_many :flights, :through => :aircraft

end

