module Gateways
  class Coordinates
    def initialize(postcodes: [])
      @postcodes = postcodes
    end

    def fetch_coordinates
      response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: postcodes })

      result = JSON.parse(response.body)

      if result['result'].length < 2
        return { success: false, coordinates: [], error: "Invalid postcode" }
      else
        coordinates = []
        result["result"].each do |o|
          next if o["result"].nil?

          longitude = o["result"]["longitude"]
          latitude = o["result"]["latitude"]
          coordinates << [latitude, longitude]
        end

        return { success: false, coordinates: coordinates, error: nil }
      end
    end

  private

    attr_reader :postcodes
  end
end
