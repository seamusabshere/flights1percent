class FlightsController < ApplicationController

  def index
    @flights = Flight.flights("IBM")['results']
    render :json => @flights
  end

end

