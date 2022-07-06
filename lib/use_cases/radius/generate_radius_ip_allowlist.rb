module UseCases
  module Radius
    class GenerateRadiusIpAllowlist
      def execute
        convert_for_freeradius(deduped_ips).join
      end

    private

      def deduped_ips
        Ip.joins(:location).to_a.uniq(&:address)
      end

      def convert_for_freeradius(ips)
        ips.map do |ip|
          "client #{ip.address.tr('.', '-')} {
      ipaddr = #{ip.address}
      secret = #{ip.location.radius_secret_key}
    }
    "
        end
      end
    end
  end
end
