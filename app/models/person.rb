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
  
  def flights
    @flights ||= aircraft.map(&:flights).flatten.sort do |a, b|
      a.date <=> b.date
    end
  end

  def annualized_emissions
    total_emissions / total_timeframe
  end
  
  def total_emissions
    flights.map(&:emission).compact.sum
  end
  
  def total_timeframe
    (flights.last.date - flights.first.date) / 60 / 60 / 24 / 365
  end
  
  def average_people
    annualized_emissions / 1_283.85764
  end
end
