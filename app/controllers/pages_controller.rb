class PagesController < ApplicationController
  def index
    params[:id] = 'index'
    show
  end
  
  def show
    @title = current_title unless params[:id] == 'index'
    send params[:id].to_sym if %w(travel).include? params[:id]
    render :template => current_page
  rescue ActionView::MissingTemplate
    render :nothing => true, :status => :not_found
  end

  private

  def travel
    @people = Person.all
    @new_footprints = []
    @people.each do |person|
      next if person.full_name == 'Angelina Jolie'
      @new_footprints.push({
        name: person.full_name,
        percentage_in_set: 20,
        people_equivalent: person.average_people.round,
        emissions_per_year: person.annualized_emissions.round,
        bio: person.blurb,
        percentage_in_set: "10"
      })
    end
  end

  protected

  def current_title
    params[:id].to_s.humanize
  end

  def current_page
    "pages/#{params[:id].to_s.underscore}"
  end
end


















