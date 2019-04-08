class Admin::GovwifiMapController < AdminController
  def index
    @postcodes = Location.pluck(:postcode)

    @coordinates = convert_postcodes
  end

  def convert_postcodes
    Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
  end
end
