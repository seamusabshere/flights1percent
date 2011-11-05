class Person < ActiveRecord::Base

  set_primary_key :full_name

  col :full_name

  data_miner do
    import "the list", :url => 'https://docs.google.com/spreadsheet/pub?key=0AtyCBJLCFHlwdDAwSUY0OU01dWYwY0VGX0tiUjl5Q0E&single=true&gid=1&output=csv' do
      key 'full_name', :field_name => 'Person'
    end
  end
  
  has_many :aircraft_registrations, :foreign_key => 'full_name'
  has_many :aircraft, :through => :aircraft_registrations

end
