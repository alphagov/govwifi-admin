class Admin::GovwifiMapController < AdminController
  def index
    @postcodes = Location.pluck(:postcode)
    @coordinates = convert_postcodes_to_coordinates
  end

  def convert_postcodes_to_coordinates
    results = Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates

    results.map { |v| [v[:latitude], v[:longitude]] }
  end
end
