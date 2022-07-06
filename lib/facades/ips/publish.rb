module Facades
  module Ips
    class Publish
      def execute
        publish_for_performance_platform
        publish_radius_allowlist
      end

    private

      def publish_for_performance_platform
        UseCases::PerformancePlatform::PublishLocationsIps.new(
          destination_gateway: Gateways::S3.new(
            bucket: ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_BUCKET"),
            key: ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY"),
          ),
          source_gateway: Gateways::Ips.new,
        ).execute
      end

      def publish_radius_allowlist
        UseCases::Radius::PublishAllowlist.new(
          destination_gateway: Gateways::S3.new(
            bucket: ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_BUCKET"),
            key: ENV.fetch("S3_ALLOWLIST_OBJECT_KEY"),
          ),
          generate_allowlist: UseCases::Radius::GenerateRadiusIpAllowlist.new,
        ).execute
      end
    end
  end
end
