class SuperAdmin::Locations::MapController < SuperAdminController
  def index
    @postcodes = Location.pluck(:postcode)
    @coordinates = convert_postcodes_to_coordinates
  end

  def convert_postcodes_to_coordinates
    UseCases::Administrator::GetPostcodeCoordinates.new(
      postcodes_gateway: Gateways::Coordinates.new(postcodes: @postcodes),
    ).execute
  end
end
