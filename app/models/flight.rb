class Flight < ActiveRecord::Base
  class << self
    def cacheme
      all.each do |flight|
        flight.cacheme!
      end
      nil
    end
  end

  set_primary_key :row_hash
  
  col :row_hash
  col :raw_wsj_data, :type => :text
  col :raw_emission_data, :type => :text
  col :tail_number
  col :carbon_object_value, :type => :float
  col :arrival_date, :type => :datetime
  col :person_id
  
  default_scope :order => :arrival_date
  
  belongs_to :aircraft, :foreign_key => 'tail_number'
  belongs_to :person

TAILS = %w(
N846QM N813QS
N531AF N724AF N757AF
N145K N245K N265K N302K N345K N532GP N545K N745K
N1KE
N1EB
N48JA
N718MC
N54SL
N707JT N492JT
N2N
N1AG
N477JB
N47EG N5MV N900MV
N610AB
N56L N889NC N89NC
N608WM N134WM N194WM N307MD N387WM N887WM )

  USER_AGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Ubuntu/10.10 (maverick) Firefox/3.6.23"

  def self.flight_count
    TAILS.each do |tail|
      cnt = where(tail_number: tail).count
      puts "#{tail}: #{cnt}"
    end
  end

  # BLANCA+PALOMA%2C+LLC
  def self.tail_numbers(company)
    header = { 'Accept' => 'application/json',
                 'Referer' => "http://projects.wsj.com/jettracker/",
                 'User-Agent' => USER_AGENT
               }

      query = { 'term' => company, 'col' => 'tag_op'}

      request = HTTPClient.get(
            "http://projects.wsj.com/jettracker/autocomplete_lookup.php",
            query, header
            )

    response = JSON.parse(request.body)
    tail_numbers = response.collect{ |x| x['text']}.join(",")
  end

  def self.pull(tn)
    # cache tail numbers
    #tns = tail_numbers(company)
    # Get and save the first page of flights so
    # we can get the total count
    flights = flight_results(tn, 0)
    save_flights(flights, tn)
    # Determine how many pages there are
    count = flights['meta']['totalcount']
    pages = (count.to_i / 50)
    # Iterate through the remaining pages
    (1..pages).each do |page|
      flights = flight_results(tn, page)
      save_flights(flights, tn)
      sleep(10)
    end if (pages > 0)
  end

  def self.save_flights(flights, tn)
    flights['results'].each do |wsj_data|
      flight = find_or_initialize_by_row_hash HashDigest.hexdigest(wsj_data)
      flight.wsj_data = wsj_data
      flight.tail_number = tn
      flight.save!
    end
  end

  # BLANCA%20PALOMA%2C%20LLC
  #http://projects.wsj.com/jettracker/flights.php?op=BLANCA%20PALOMA%2C%20LLC&tag=N901SG&dc=&ac=&dds=&dde=&ads=&ade=&any_city=&p=1&sort=d
  def self.flight_results(tn, page = 0)

    header = { 'Accept' => 'application/json',
                 'Referer' => "http://projects.wsj.com/jettracker/",
                 'User-Agent' => USER_AGENT
               }

      query = { 'op' => '', 'tag' => tn, 'p' => page, 'sort' => 'd'}

      request2 = HTTPClient.get(
            "http://projects.wsj.com/jettracker/flights.php",
            query, header
            )

    flights = MultiJson.decode(request2.body)
  end

  def set_emissions
    emission_data
    save!
  end

  def self.set_emissions
    while f = where(arel_table[:carbon_object_value].eq(nil)).order('random()').first
      puts f.send(:request).inspect
      f.set_emissions
      puts "Emission set for #{f.row_hash}: #{f.carbon_object_value}"
    end
  end

  def wsj_data
    ::Hashie::Mash.new ::MultiJson.decode(raw_wsj_data)
  end

  def wsj_data=(hsh)
    self.raw_wsj_data = ::MultiJson.encode hsh
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
        puts "blew up"
      end
    end
    ::Hashie::Mash.new hsh
  end

  def origin_airport
    wsj_data.DEPCODE
  end

  def destination_airport
    wsj_data.ARRCODE
  end

  def emission
    carbon_object_value
  end
  
  def date
    arrival_date
  end
  
  def cacheme!
    return if arrival_date.present?
    self.arrival_date = Time.parse(wsj_data.ARRDATE)
    self.person = aircraft.try(:registrations).try(:first).try(:person)
    save!
  end
  
  private

  def request
    {
      :emitter => 'Flight',
      :origin_airport => origin_airport,
      :destination_airport => destination_airport,
      :trips => 1,
      :segments_per_trip => 1,
      :aircraft => aircraft.try(:name),
      :seats => 5,
      :load_factor => 1
    }
  end
end


# == Schema Information
#
# Table name: flights
#
#  row_hash            :string(255)     not null, primary key
#  raw_wsj_data        :text
#  raw_emission_data   :text
#  tail_number         :string(255)
#  carbon_object_value :float
#

