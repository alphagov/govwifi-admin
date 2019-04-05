class Admin::GovwifiMapController < AdminController
  def index
    @postcodes = Location.pluck(:postcode)
    @coordinates = convert_postcodes

    pp convert_postcodes

    # get all postcodes

    # send postcodes to gateway and save coordinates

    # combine coordinates into array of the correct shape

    # pass array of coordinates to view
  end

  def convert_postcodes
    Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
  end
end
