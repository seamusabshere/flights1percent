class AircraftRegistration < ActiveRecord::Base
  set_primary_key :stupid_key

  col :stupid_key
  col :full_name
  col :tail_number
  col :seats, :type => :integer
  # add_index [:tail_number, :full_name], :unique => true
  
  belongs_to :aircraft, :foreign_key => 'tail_number'
  
  class Parser
    def apply(row)
      row['Tail numbers'].split(/\s*,\s*/).map do |tail_number|
        { 'full_name' => row['Person'], 'tail_number' => tail_number, 'stupid_key' => [row['Person'], tail_number].join }
      end
    end
  end

  data_miner do
    import("the list",
            :url => 'https://docs.google.com/spreadsheet/pub?key=0AtyCBJLCFHlwdDAwSUY0OU01dWYwY0VGX0tiUjl5Q0E&single=true&gid=1&output=csv',
            :transform => { :class => Parser }) do
      key 'stupid_key'
      store 'full_name'
      store 'tail_number'
    end
    
    import "seat capacities", :url => 'https://docs.google.com/spreadsheet/pub?key=0AtyCBJLCFHlwdDAwSUY0OU01dWYwY0VGX0tiUjl5Q0E&single=true&gid=2&output=csv' do
      key 'tail_number', :field_name => 'N-NUMBER'
      store 'seats', :field_name => 'NO-SEATS'
    end
  end
end

# == Schema Information
#
# Table name: aircraft_registrations
#
#  stupid_key  :string(255)     not null, primary key
#  full_name   :string(255)
#  tail_number :string(255)
#  seats       :integer
#

