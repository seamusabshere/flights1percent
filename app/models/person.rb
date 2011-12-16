class Person < ActiveRecord::Base

  set_primary_key :full_name

  col :full_name
  col :blurb

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
  cache_method :total_emissions
  
  def total_timeframe
    (flights.last.date - flights.first.date) / 60 / 60 / 24 / 365
  end
  cache_method :total_timeframe
  
  def average_people
    annualized_emissions / 1_283.85764
  end
  
  def hash
    full_name.hash
  end
end

# == Schema Information
#
# Table name: people
#
#  full_name :string(255)     not null, primary key
#

