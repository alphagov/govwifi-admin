module Gateways
  class Coordinates
    def initialize(postcodes: [] )
      @postcodes = postcodes
    end

    def fetch_coordinates
      response = HTTParty.post("http://api.postcodes.io/postcodes")

      result = JSON.parse(response.body)

      if result['status'] == 404
        return { success: false, coordinates: [], error: "Invalid postcode" }
      else
        coordinates = []

        result["result"].each do | o |
          longitude = o["result"]["longitude"]
          latitude = o["result"]["latitude"]
          coordinates << [longitude, latitude]
        end

        { success: true, coordinates: coordinates, error: nil }
      end
    end

  private

    attr_reader :postcodes
  end
end
