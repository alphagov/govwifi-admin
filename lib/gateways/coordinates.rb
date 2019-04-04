module Gateways
  class Coordinates
    def initialize(postcode:)
      @postcode = postcode
    end

    def fetch_coordinates
      response = HTTParty.get("http://api.postcodes.io/postcodes/#{postcode}")
      result = JSON.parse(response.body)

      if result['status'] == 404
        return { success: false, coordinates: [], error: "Invalid postcode" }
      else
        longitude = result['result']['longitude']
        latitude = result['result']['latitude']
        { success: true, coordinates: [longitude, latitude], error: nil }
      end
    end

  private

    attr_reader :postcode
  end
end
