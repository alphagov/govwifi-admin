module Facades
  module Ips
    class Publish
      def execute
        publish_for_performance_platform
        publish_radius_whitelist
      end

    private

      def publish_for_performance_platform
        ips = Ip.pluck(:address, :location_id).map do |ip|
          {
            ip: ip[0],
            location_id: ip[1],
          }
        end
        Services.s3_client.put_object(body: ips.to_json,
                                      bucket: ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_BUCKET"),
                                      key: ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY"))
      end

      def publish_radius_whitelist
        whitelist = UseCases::Radius::GenerateRadiusIpWhitelist.new.execute
        Services.s3_client.put_object(body: whitelist,
                                      bucket: ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_BUCKET"),
                                      key: ENV.fetch("S3_WHITELIST_OBJECT_KEY"))
      end
    end
  end
end
