class SuperAdmin::Locations::MapController < SuperAdminController
  def index
    @postcodes = Location.pluck(:postcode)
    @coordinates = Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
  end
end
