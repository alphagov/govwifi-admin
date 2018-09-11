module Gateways
  class Statistics
    def initialize
    end

    def fetch_statistics
      repository.all.map do |ip|
        {
          ip: ip.address,
          location_id: ip.location_id
        }
      end
    end

private

    def repository
      Ip
    end
  end
end
