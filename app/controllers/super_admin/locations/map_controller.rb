class SuperAdmin::Locations::MapController < ApplicationController
  include SuperUserConcern

  def index
    @postcodes = Location.pluck(:postcode)
    @coordinates = Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
  end
end
