module Gateways
  class Ips
    def fetch_ips
      Ip.all.map do |ip|
        {
          ip: ip.address,
          location_id: ip.location_id,
        }
      end
    end
  end
end
