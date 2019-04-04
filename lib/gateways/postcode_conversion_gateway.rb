require 'httparty'
module Gateways
  class PostcodeConversionGateway
    def convert_postcode_to_long_and_lat(postcode)
      trimed_postcode = postcode.gsub(/\s+/, "")

      response = HTTParty.get("http://api.postcodes.io/postcodes/#{trimed_postcode}")
      result = JSON.parse(response.body)

      if result['status'] == 404
        return result['error']
      else
        longitude = result['result']['longitude']
        latitude = result['result']['latitude']

        coordinates = [longitude, latitude]
      end
    end
  end
end
