module Gateways
  class Coordinates
    def initialize(postcodes: [])
      @postcodes = postcodes
    end

    def fetch_coordinates(batch_size: 100)
      postcode_results = postcodes.each_slice(batch_size).map do |batch|
        response = HTTParty.post("http://api.postcodes.io/postcodes", body: { postcodes: batch })
        result = JSON.parse(response.body)

        result["result"].map do |o|
          next if o["result"].nil?

          {
            latitude: o["result"]["latitude"],
            longitude: o["result"]["longitude"]
          }
        end
      end

      postcode_results.flatten.compact
    end

  private

    attr_reader :postcodes
  end
end
