module Gateways
  class Ips
    def fetch_ips
      Ip.all
    end
  end
end
