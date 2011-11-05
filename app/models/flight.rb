class Flight < ActiveRecord::Base

  set_primary_key :row_hash

  col :row_hash
  col :raw_wsj_data, :type => :text
  col :raw_emission_data, :type => :text

  USER_AGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Ubuntu/10.10 (maverick) Firefox/3.6.23"

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

  def self.pull(company)
    # cache tail numbers
    tns = tail_numbers(company)
    # Get and save the first page of flights so
    # we can get the total count
    flights = flight_results(company, tns, 0)
    save_flights(flights)
    # Determine how many pages there are
    count = flights['meta']['totalcount']
    pages = (count.to_i / 50)
    # Iterate through the remaining pages
    (1..pages).each do |page|
      flights = flight_results(company, tns, page)
      save_flights(flights)
      sleep(10)
    end if (pages > 0)
  end

  def self.save_flights(flights)
    flights['results'].each do |wsj_data|
      flight = find_or_initialize_by_row_hash HashDigest.hexdigest(wsj_data)
      flight.wsj_data = wsj_data
      flight.save!
    end
  end

  # BLANCA%20PALOMA%2C%20LLC
  #http://projects.wsj.com/jettracker/flights.php?op=BLANCA%20PALOMA%2C%20LLC&tag=N901SG&dc=&ac=&dds=&dde=&ads=&ade=&any_city=&p=1&sort=d
  def self.flight_results(company, tail_numbers, page = 0)

    header = { 'Accept' => 'application/json',
                 'Referer' => "http://projects.wsj.com/jettracker/",
                 'User-Agent' => USER_AGENT
               }

      query = { 'op' => CGI.escape(company).gsub('+', '%20'), 'tag' => tail_numbers, 'p' => page, 'sort' => 'd'}

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
      live_query_response = begin; ::BrighterPlanetApi.cm1.query(request); rescue; { :error => $!.inspect }; end
      self.emission_data = live_query_response
      live_query_response
    end
    ::Hashie::Mash.new hsh
  end

  #::HTTPClient.get url
  #       ::Hashie::Mash.new ::MultiJson.decode(response.body)

  def origin_airport
    wsj_data.DEPCODE
  end

  def destination_airport
    wsj_data.ARRCODE
  end

  def emission
    emission_data.decisions.carbon.object.value
  end

  private

  def request
    {
      :emitter => 'Flight',
      :origin_airport => origin_airport,
      :destination_airport => destination_airport
    }
  end
end

