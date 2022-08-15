module Gateways
  class Coordinates
    def initialize(postcodes: [])
      @postcodes = postcodes
    end

    def fetch_coordinates(batch_size: 100)
      postcodes.each_slice(batch_size).flat_map do |batch|
        response = HTTParty.post("https://api.postcodes.io/postcodes", body: { postcodes: batch })
        payload = JSON.parse(response.body)

        payload["result"].pluck("result").reject(&:nil?).map do |o|
          [o["latitude"], o["longitude"]]
        end
      end
    end

  private

    attr_reader :postcodes
  end
end
