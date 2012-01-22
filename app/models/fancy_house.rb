class FancyHouse < ActiveRecord::Base
  include Haus # provides average_houses and will provide emission estimate eventually
  
  set_primary_key :name
  
  col :name
  col :price
  col :square_feet, :type => :float
  col :floors, :type => :float
  col :bedrooms, :type => :float
  col :bathrooms, :type => :float
  col :zip_code
  col :urbanity
  col :construction_year
  col :building_class_category
  col :raw_emission_data, :type => :text
  col :carbon_object_value, :type => :float
  
  data_miner do
    import(
      "fancy houses scraped by David and Andy",
      :url => 'https://docs.google.com/spreadsheet/pub?hl=en_US&hl=en_US&key=0AtyCBJLCFHlwdGpjQ2dQYkN6TnkzYlBPZXVfNUFrOHc&single=true&gid=0&output=csv',
      :select => Proc.new { |row| row['name'].present? }
    ) do
      key 'name'
      store 'price'
      store 'square_feet'
      store 'floors'
      store 'bedrooms'
      store 'bathrooms'
      store 'zip_code'
      store 'urbanity'
      store 'construction_year'
    end
  end
  
  def enuf?
    true
  end
  
  def floorspace_estimate
    if square_feet.present?
      square_feet * 0.09290304 # sq metres
    end
  end
  
  def residence_class
    case building_class_category
    when /condo/i
      'Apartment in a building with 5 or more units'
    when /mansion/i
      'Single-family detached house (a one-family house detached from any other house)'
    end
  end

  def blurb
    parts = []
    parts << "#{square_feet} square feet" if square_feet.present?
    parts << "$#{price}" if price.present?
    parts.join(' and ')
  end
end
