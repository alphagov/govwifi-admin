module Services
  class HandleNewIp
    def initialize(ip:)
      @ip = ip
    end

    def execute
      publish_for_performance_platform
      publish_radius_whitelist
    end

  private

    def publish_for_performance_platform
      UseCases::PerformancePlatform::PublishLocationsIps.new(
        destination_gateway: Gateways::S3.new(
          bucket: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_BUCKET'),
          key: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY')
        ),
        source_gateway: Gateways::Ips.new
      ).execute
    end

    def publish_radius_whitelist
      PublishWhitelist.new(
        destination_gateway: Gateways::S3.new(
          bucket: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_BUCKET'),
          key: ENV.fetch('S3_WHITELIST_OBJECT_KEY')
        ),
        generate_whitelist: UseCases::Radius::GenerateRadiusIpWhitelist.new
      ).execute
    end
  end
end
