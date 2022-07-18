module UseCases
  module Radius
    class PublishRadiusIpAllowlist
      def execute
        data = Ip.includes(:location).map do |ip|
          <<~ELEMENT
            client #{ip.address.tr('.', '-')} {
                  ipaddr = #{ip.address}
                  secret = #{ip.location.radius_secret_key}
            }
          ELEMENT
        end
        Gateways::S3.new(**Gateways::S3::RADIUS_IPS_ALLOW_LIST).write(data.join)
      end
    end
  end
end
