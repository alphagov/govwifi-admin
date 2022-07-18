module UseCases
  module PerformancePlatform
    class PublishLocationsIps
      def execute
        ip_data = Ip.all.select(:address, :location_id).map do |ip|
          {
            ip: ip.address,
            location_id: ip.location_id,
          }
        end
        Gateways::S3.new(**Gateways::S3::LOCATION_IPS).write(ip_data.to_json)
      end
    end
  end
end
