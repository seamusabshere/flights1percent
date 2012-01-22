module Haus
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
  end
  
  AVERAGE_FLOORSPACE = 1700 * 0.09290304 # http://en.wikipedia.org/wiki/Average_Joe
  def floorspace_outsizedness
    if floorspace_estimate.present?
      floorspace_estimate / AVERAGE_FLOORSPACE
    end
  end
  
  AVERAGE_BEDROOMS = 2.35 # median calculated from http://www.census.gov/apsd/cqc/cqc9.pdf
  def bedroom_outsizedness
    if bedrooms.present? and bedrooms > 0
      bedrooms.to_f / AVERAGE_BEDROOMS
    end
  end
  
  def average_houses
    [ floorspace_outsizedness, bedroom_outsizedness ].compact.max
  end
  cache_method :average_houses
end

=begin

def set_emissions
  emission_data
  save!
end

def request
  hsh = {
    :emitter => 'Residence',
    :floorspace_estimate => floorspace_estimate,
    :bedrooms => bedrooms,
    :bathrooms => bathrooms,
    :zip_code => zip_code,
    :construction_year => construction_year,
    :residence_class => residence_class
  }
  hsh[:urbanity] = urbanity if respond_to?(:urbanity)
  hsh[:floors] = floors if respond_to?(:floors)
  hsh
end

def emission_data=(hsh)
  self.raw_emission_data = ::MultiJson.encode hsh
end

def emission_data
  hsh = if (saved_emission_data = raw_emission_data)
    ::MultiJson.decode saved_emission_data
  else
    begin
      live_query_response = ::BrighterPlanetApi.cm1.query(request)
      self.emission_data = live_query_response
      self.carbon_object_value = live_query_response.decisions.try(:carbon).try(:object).try(:value)
      live_query_response
    rescue
      puts "blew up on #{request.inspect}"
    end
  end
  ::Hashie::Mash.new hsh
end
=end
