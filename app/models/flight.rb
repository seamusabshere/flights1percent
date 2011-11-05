class Flight < ActiveRecord::Base
  
  col :raw_wsj_data, :type => :text
  col :raw_emission_data, :type => :text

  USER_AGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Ubuntu/10.10 (maverick) Firefox/3.6.23"

  def self.pull(company, json = false)
    request = Typhoeus::Request.get(
      "http://projects.wsj.com/jettracker/autocomplete_lookup.php?term=#{company}&col=tag_op",
        :headers       => {:Accept => "application/json"},
        :timeout       => 10000, # milliseconds
        :user_agent    => USER_AGENT,
        :referrer      => "http://projects.wsj.com/jettracker/"
      )
    response = JSON.parse(request.body)
    tail_numbers = response.collect{ |x| x['text']}.join(",")
    request2 = Typhoeus::Request.get(
      "http://projects.wsj.com/jettracker/flights.php?op=IBM&tag=#{tail_numbers}&dc=&ac=&dds=&dde=&ads=&ade=&any_city=&p=0&sort=d",
        :headers       => {:Accept => "application/json"},
        :timeout       => 10000, # milliseconds
        :user_agent    => USER_AGENT,
        :referrer      => "http://projects.wsj.com/jettracker/"
      )
    flights = MultiJson.decode(request2.body)

    flights['results'].each do |wsj_data|
      flight = new :wsj_data => wsj_data.to_hash
      flight.save!
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

