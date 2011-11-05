class Flight

  USER_AGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Ubuntu/10.10 (maverick) Firefox/3.6.23"

  def self.flights(company, json = false)
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
    if json
      MultiJson.decode(request2.body)
    else
      Hashie::Mash.new MultiJson.decode(request2.body)
    end
  end

  #::HTTPClient.get url
  #       ::Hashie::Mash.new ::MultiJson.decode(response.body)



end

