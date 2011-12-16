class PagesController < ApplicationController
  def home
      @people = Person.all
      @new_footprints = []
      @people.each do |person|
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
end














