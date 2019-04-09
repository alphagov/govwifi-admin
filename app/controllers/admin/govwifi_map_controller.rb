class Admin::GovwifiMapController < AdminController
  def index
    @postcodes = Location.pluck(:postcode)
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    @coordinates = convert_postcodes[:coordinates]
  end

  def convert_postcodes
    Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
=======
=======
    @coordinates = convert_postcodes

<<<<<<< HEAD
>>>>>>> GETS COORDINATES
=======
    pp convert_postcodes

>>>>>>> validate invalid postcodes
    # get all postcodes
=======
>>>>>>> plots on google maps

=======
>>>>>>> done
    @coordinates = convert_postcodes
    @formatted_coordinates = @coordinates[:coordinates].flatten
=======
    @coordinates = convert_postcodes[:coordinates]
>>>>>>> no api works
  end

<<<<<<< HEAD
  def convert_postcode
    UseCases::Administrator::ConvertPostcode.new(
      postcode_gateway: Gateways::Coordinates.new(postcode: @postcodes)
    ).execute
>>>>>>> gateway takes array of postcodes
=======
  def convert_postcodes
    Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates
>>>>>>> GETS COORDINATES
=======
    @coordinates = convert_postcodes
  end

  def convert_postcodes
    results = Gateways::Coordinates.new(postcodes: @postcodes).fetch_coordinates

    results.map { |v| [v[:latitude], v[:longitude]] }
>>>>>>> works
  end
end
