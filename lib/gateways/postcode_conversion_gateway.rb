module Gateways
  class PostcodeConversionGateway
    def initialize(postcode:)
      @postcode = postcode
    end

    def fetch_coordinates
      trimed_postcode = postcode.gsub(/\s+/, "")

      response = HTTParty.get("http://api.postcodes.io/postcodes/#{trimed_postcode}")
      result = JSON.parse(response.body)

      if result['status'] == 404
        result['error']
      else
        longitude = result['result']['longitude']
        latitude = result['result']['latitude']
        [longitude, latitude]
      end
    end

  private

    attr_reader :postcode
  end
end
