module Gateways
  class Coordinates
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    def initialize(postcodes: [])
      @postcodes = postcodes
    end

<<<<<<< HEAD
    def fetch_coordinates
      combined_coordinates = []
<<<<<<< HEAD

      postcodes.each_slice(100) do |batch|
=======
    def fetch_coordinates(batch_size: 100)
<<<<<<< HEAD
      postcodes.each_slice(batch_size).map do |batch|
>>>>>>> works
=======
      postcode_results = postcodes.each_slice(batch_size).map do |batch|
>>>>>>> done
        response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: batch })
        result = JSON.parse(response.body)

        result["result"].map do |o|
          next if o["result"].nil?

          {
            latitude: o["result"]["latitude"],
            longitude: o["result"]["longitude"]
          }
        end
<<<<<<< HEAD
<<<<<<< HEAD
      end
=======
    def initialize(postcode:)
      @postcode = postcode
=======
    def initialize(postcodes: [] )
=======
    def initialize(postcodes: [])
>>>>>>> clean up again
      @postcodes = postcodes
>>>>>>> gateway takes array of postcodes
    end

    def fetch_coordinates
      response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: postcodes })
=======
>>>>>>> batches

      postcodes.each_slice(100) do |batch|
        response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: batch })
        result = JSON.parse(response.body)
        combined_coordinates << result
        final_coordinates = combined_coordinates.first

<<<<<<< HEAD
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
        result["result"].each do |o|
          next if o["result"].nil?
=======
        if final_coordinates['result'].length < 2
          return { success: false, coordinates: [], error: "Invalid postcode" }
        else
          coordinates = []
          final_coordinates["result"].each do |o|
            next if o["result"].nil?
>>>>>>> batches

            longitude = o["result"]["longitude"]
            latitude = o["result"]["latitude"]
            coordinates << [latitude, longitude]
          end

          return { success: false, coordinates: coordinates, error: nil }
        end
      end
>>>>>>> more tests
=======
      end.flatten.compact
>>>>>>> works
=======
      end

      postcode_results.flatten.compact
>>>>>>> done
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
