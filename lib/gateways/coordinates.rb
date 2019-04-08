module Gateways
  class Coordinates
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
    end

  private

    attr_reader :postcodes
  end
end
