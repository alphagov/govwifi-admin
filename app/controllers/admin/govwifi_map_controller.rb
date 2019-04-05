class Admin::GovwifiMapController < AdminController
  def index
    @postcodes = Location.pluck(:postcode)
<<<<<<< HEAD
    @coordinates = convert_postcodes[:coordinates]
  end

  def convert_postcodes
    Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
=======
    # get all postcodes

    # send postcodes to gateway and save coordinates

    # combine coordinates into array of the correct shape

    # pass array of coordinates to view
  end

  def convert_postcode
    UseCases::Administrator::ConvertPostcode.new(
      postcode_gateway: Gateways::Coordinates.new(postcode: @postcodes)
    ).execute
>>>>>>> gateway takes array of postcodes
  end
end
