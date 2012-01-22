class Domicile < ActiveRecord::Base
  class << self
    def pull_zillow_details(delay = 0.1)
      all.each do |domicile|
        domicile.pull_zillow_details!
        sleep delay
      end
    end
  end
  
  include Haus

  BUILDING_CLASSES = [
    /home/i,
    /apart/i,
    /condo/i,
  ]
  
  SELECTOR = Proc.new do |row|
    row['COMMERCIAL UNITS'].to_i == 0 and
    (0..1).include?(row['RESIDENTIAL UNITS'].to_i) and
    row['SALE PRICE'].to_f > 0 and
    BUILDING_CLASSES.any? { |bc| row['BUILDING CLASS CATEGORY'] =~ bc }
  end
  
  set_primary_key :row_hash
  
  col :row_hash
  col :bbl # borough + block + lot... 4/99999/99
  col :zpid
  col :address # includes apartment number
  col :neighborhood
  col :zip_code, :type => :integer
  col :gross_square_feet, :type => :float
  col :construction_year, :type => :integer
  col :price, :type => :float
  col :block, :type => :integer
  col :lot, :type => :integer
  col :borough, :type => :integer
  col :building_class_category
  col :bedrooms, :type => :integer
  col :bathrooms, :type => :float
  col :zillow_xml, :type => :text
  col :tried_zillow_at, :type => :datetime
  col :raw_emission_data, :type => :text
  col :carbon_object_value, :type => :float
    
  data_miner do
    import(
      "2011 New York City Sales Data",
      :url => 'http://www.nyc.gov/html/dof/html/pdf/rolling_sales/rollingsales_manhattan.xls',
      :skip => 4,
      :select => SELECTOR
    ) do
      key 'row_hash'
      store 'bbl', :synthesize => Proc.new { |row| row.slice('BOROUGH', 'BLOCK', 'LOT').values.map(&:to_i).join('/') }
      store 'address', :synthesize => Proc.new { |row| [row['ADDRESS'], row['APARTMENT NUMBER']].compact.join(' ') }
      store 'neighborhood', :field_name => 'NEIGHBORHOOD'
      store 'zip_code', :field_name => 'ZIP CODE'
      store 'gross_square_feet', :field_name => 'GROSS SQUARE FEET'
      store 'construction_year', :field_name => 'YEAR BUILT'
      store 'price', :field_name => 'SALE PRICE'
      store 'block', :field_name => 'BLOCK'
      store 'lot', :field_name => 'LOT'
      store 'borough', :field_name => 'BOROUGH'
      store 'building_class_category', :field_name => 'BUILDING CLASS CATEGORY'
    end

    # don't forget to pull details hey!
  end
  
  def floorspace_estimate
    gross_square_feet * 0.09290304 # sq metres
  end
    
  def residence_class
    case building_class_category
    when /home/i
      'Single-family detached house (a one-family house detached from any other house)'
    else
      'Apartment in a building with 5 or more units'
    end
  end
  
  def enuf?
    gross_square_feet.to_f > 0 or bedrooms.to_i > 0
  end

  def tried_zillow?
    bedrooms.present? or tried_zillow_at.present?
  end

  def pull_zillow_details!
    return if tried_zillow?
    
    data = Rubillow::PropertyDetails.deep_search_results({ :address => address, :citystatezip => zip_code })

    self.tried_zillow_at = Time.now
    self.zillow_xml = data.xml

    if data.success?
      self.zpid = data.zpid
      self.bathrooms = data.bathrooms
      self.bedrooms = data.bedrooms
    end
    
    save!
  end
end
