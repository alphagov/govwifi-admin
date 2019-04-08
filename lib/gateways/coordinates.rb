module Gateways
  class Coordinates
<<<<<<< HEAD
<<<<<<< HEAD
    def initialize(postcodes: [])
      @postcodes = postcodes
    end

    def fetch_coordinates
      combined_coordinates = []

      postcodes.each_slice(100) do |batch|
        response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: batch })
        result = JSON.parse(response.body)
        combined_coordinates << result
        final_coordinates = combined_coordinates.first

        if final_coordinates['result'].length < 2
          return { success: false, coordinates: [], error: "Invalid postcode" }
        else
          coordinates = []
          final_coordinates["result"].each do |o|
            next if o["result"].nil?

            longitude = o["result"]["longitude"]
            latitude = o["result"]["latitude"]
            coordinates << [latitude, longitude]
          end

          return { success: false, coordinates: coordinates, error: nil }
        end
      end
=======
    def initialize(postcode:)
      @postcode = postcode
=======
    def initialize(postcodes: [] )
      @postcodes = postcodes
>>>>>>> gateway takes array of postcodes
    end

    def fetch_coordinates
      response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: postcodes })

      result = JSON.parse(response.body)

<<<<<<< HEAD
<<<<<<< HEAD
      longitude = result['result']['longitude']
      latitude = result['result']['latitude']
      { success: true, coordinates: [longitude, latitude], error: nil }
>>>>>>> refac
=======
      if result['status'] == 404
=======
      if result['result'].length < 2
>>>>>>> validate invalid postcodes
        return { success: false, coordinates: [], error: "Invalid postcode" }
      else
        coordinates = []
        result["result"].each do | o |
          next if o["result"].nil?
          longitude = o["result"]["longitude"]
          latitude = o["result"]["latitude"]
          coordinates << [latitude, longitude]
        end

        coordinates
      end
>>>>>>> more tests
    end

  private

<<<<<<< HEAD
<<<<<<< HEAD
    attr_reader :postcodes
=======
    attr_reader :postcode
>>>>>>> refac
=======
    attr_reader :postcodes
>>>>>>> gateway takes array of postcodes
  end
end
