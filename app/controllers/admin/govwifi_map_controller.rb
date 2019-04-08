class Admin::GovwifiMapController < AdminController
  def index
    @postcodes = Location.pluck(:postcode)
    @coordinates = convert_postcodes
    @formatted_coordinates = @coordinates[:coordinates].flatten
  end

  def convert_postcodes
    Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
  end
end
