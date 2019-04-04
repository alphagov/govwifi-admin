module Gateways
  class Coordinates
    def initialize(postcode:)
      @postcode = postcode
    end

    def fetch_coordinates
      response = HTTParty.get("http://api.postcodes.io/postcodes/#{postcode}")
      result = JSON.parse(response.body)

      longitude = result['result']['longitude']
      latitude = result['result']['latitude']
      { success: true, coordinates: [longitude, latitude], error: nil }
    end

  private

    attr_reader :postcode
  end
end
